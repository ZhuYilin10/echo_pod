import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:audio_service/audio_service.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../ai_agent/ai_agent_screen.dart';
import '../podcast_detail/podcast_detail_screen.dart';

import '../common/download_button.dart';
import 'package:m3e_collection/m3e_collection.dart';
import '../../core/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EpisodeDetailScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const EpisodeDetailScreen({super.key, required this.episode});

  @override
  ConsumerState<EpisodeDetailScreen> createState() =>
      _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends ConsumerState<EpisodeDetailScreen> {
  String? _aiSummary;
  bool _isSummarizing = false;
  Episode? _resolvedEpisode;
  bool _isResolving = false;
  String? _resolveError;

  @override
  void initState() {
    super.initState();
    // 如果来自 xyzrank（没有真实音频链接或小宇宙链接），尝试从 RSS 获取完整数据
    if (widget.episode.audioUrl == null ||
        widget.episode.audioUrl!.isEmpty ||
        widget.episode.audioUrl!.contains('xiaoyuzhoufm.com') ||
        widget.episode.description?.contains('Play count:') == true) {
      _resolveFromRss();
    }
  }

  Future<void> _resolveFromRss() async {
    setState(() {
      _isResolving = true;
      _resolveError = null;
    });

    try {
      final podcastService = ref.read(podcastServiceProvider);

      // 搜索 iTunes 获取播客信息
      final podcasts =
          await podcastService.searchPodcasts(widget.episode.podcastTitle);

      Episode? resolvedEpisode;

      if (podcasts.isNotEmpty) {
        // 方法1: 从 iTunes RSS 获取
        final podcast = podcasts.first;
        final episodes = await podcastService.fetchEpisodes(podcast.feedUrl);

        // 匹配当前单集（通过标题相似度）
        resolvedEpisode = episodes.firstWhere(
          (e) =>
              e.title.toLowerCase().trim() ==
              widget.episode.title.toLowerCase().trim(),
          orElse: () => episodes.firstWhere(
            (e) =>
                e.title.contains(widget.episode.title) ||
                widget.episode.title.contains(e.title),
            orElse: () => Episode(
              guid: widget.episode.guid,
              title: widget.episode.title,
              podcastTitle: widget.episode.podcastTitle,
              description: widget.episode.description,
              audioUrl: widget.episode.audioUrl,
              imageUrl: widget.episode.imageUrl,
              podcastFeedUrl: podcast.feedUrl,
              pubDate: widget.episode.pubDate,
              duration: widget.episode.duration,
            ),
          ),
        );
      } else if (widget.episode.audioUrl?.contains('xiaoyuzhoufm.com') ==
          true) {
        // 方法2: iTunes 找不到，尝试解析小宇宙页面（保底方案）
        final parser = ref.read(xiaoyuzhouParserServiceProvider);
        final xiaoyuzhouEpisode =
            await parser.parseUrl(widget.episode.audioUrl!);

        if (xiaoyuzhouEpisode != null) {
          resolvedEpisode = Episode(
            guid: widget.episode.guid,
            title: xiaoyuzhouEpisode.title,
            podcastTitle: xiaoyuzhouEpisode.podcastTitle,
            description: xiaoyuzhouEpisode.description,
            audioUrl: xiaoyuzhouEpisode.audioUrl,
            imageUrl: xiaoyuzhouEpisode.imageUrl ?? widget.episode.imageUrl,
            podcastFeedUrl: widget.episode.podcastFeedUrl,
            pubDate: widget.episode.pubDate,
            duration: widget.episode.duration,
          );
        }
      }

      final matchedEpisode = resolvedEpisode ??
          Episode(
            guid: widget.episode.guid,
            title: widget.episode.title,
            podcastTitle: widget.episode.podcastTitle,
            description: widget.episode.description,
            audioUrl: widget.episode.audioUrl,
            imageUrl: widget.episode.imageUrl,
            podcastFeedUrl: widget.episode.podcastFeedUrl,
            pubDate: widget.episode.pubDate,
            duration: widget.episode.duration,
          );

      if (mounted) {
        setState(() {
          _resolvedEpisode = matchedEpisode;
          _isResolving = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _resolveError = '获取数据失败: $e';
          _isResolving = false;
        });
      }
    }
  }

  void _generateSummary() async {
    setState(() => _isSummarizing = true);
    final aiService = ref.read(aiServiceProvider);
    final summary = await aiService.getEpisodeSummary(
      _displayEpisode.title,
      _displayEpisode.description ?? '',
    );
    if (mounted) {
      setState(() {
        _aiSummary = summary;
        _isSummarizing = false;
      });
    }
  }

  String _processDescription(String? description) {
    if (description == null) return '';
    final regExp = RegExp(r'(\d{1,2}:)?\d{1,2}:\d{2}');
    return description.replaceAllMapped(regExp, (match) {
      final timestamp = match.group(0)!;
      return '<a href="seek://$timestamp">$timestamp</a>';
    });
  }

  Duration _parseTimestamp(String timestamp) {
    final parts = timestamp.split(':');
    if (parts.length == 3) {
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]),
      );
    } else if (parts.length == 2) {
      return Duration(
        minutes: int.parse(parts[0]),
        seconds: int.parse(parts[1]),
      );
    }
    return Duration.zero;
  }

  void _navigateToPodcastDetail() async {
    final podcastService = ref.read(podcastServiceProvider);
    final subs = await ref.read(subscriptionsProvider.future);
    final existing =
        subs.where((p) => p.title == _displayEpisode.podcastTitle).firstOrNull;

    if (existing != null) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PodcastDetailScreen(podcast: existing)));
      }
    } else {
      final results =
          await podcastService.searchPodcasts(_displayEpisode.podcastTitle);
      if (results.isNotEmpty && mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PodcastDetailScreen(podcast: results.first)));
      }
    }
  }

  Episode get _displayEpisode => _resolvedEpisode ?? widget.episode;

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isSubscribedAsync = ref.watch(subscriptionsProvider).whenData(
        (subs) => subs.any((p) => p.title == _displayEpisode.podcastTitle));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          isSubscribedAsync.when(
            data: (isSubscribed) => TextButton.icon(
              onPressed: isSubscribed
                  ? null
                  : () async {
                      final podcastService = ref.read(podcastServiceProvider);
                      final storageService = ref.read(storageServiceProvider);
                      final results = await podcastService
                          .searchPodcasts(widget.episode.podcastTitle);
                      if (results.isNotEmpty) {
                        await storageService.subscribe(results.first);
                        ref.invalidate(subscriptionsProvider);
                        ref.invalidate(
                            isSubscribedProvider(results.first.feedUrl));
                      }
                    },
              icon: Icon(isSubscribed ? Icons.check : Icons.add,
                  size: 18, color: const Color(0xFF1C1B1F)),
              label: Text(isSubscribed ? '已订阅' : '订阅',
                  style: const TextStyle(color: Color(0xFF1C1B1F))),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1C1B1F)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            loading: () => Center(
                child: CircularProgressIndicatorM3E(
              size: CircularProgressM3ESize.s,
              activeColor: Theme.of(context).colorScheme.primary,
            )),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(width: 8),
          DownloadButton(episode: _displayEpisode),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_resolveError != null)
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error),
                        const SizedBox(height: 8),
                        Text(_resolveError!,
                            style: TextStyle(color: colorScheme.error)),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _resolveFromRss,
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'episode_artwork_${_displayEpisode.guid}',
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  ImageUtils.getHighResUrl(
                                      _displayEpisode.imageUrl)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayEpisode.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _navigateToPodcastDetail,
                              child: Text(
                                '${_displayEpisode.podcastTitle} >',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _displayEpisode.hasAudio
                          ? StreamBuilder<MediaItem?>(
                              stream: audioHandler.mediaItem,
                              builder: (context, snapshot) {
                                final isCurrent =
                                    snapshot.data?.id == _displayEpisode.guid;
                                return StreamBuilder<PlaybackState>(
                                  stream: audioHandler.playbackState,
                                  builder: (context, playbackSnapshot) {
                                    final playing =
                                        playbackSnapshot.data?.playing ?? false;
                                    final isBusy = isCurrent && playing;

                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (isCurrent)
                                          SizedBox(
                                            width: 54,
                                            height: 54,
                                            child: CircularProgressIndicatorM3E(
                                              value: _calculateProgress(
                                                  playbackSnapshot.data,
                                                  snapshot.data),
                                              activeColor: colorScheme.primary,
                                              size: CircularProgressM3ESize.m,
                                            ),
                                          ),
                                        IconButton(
                                          icon: Icon(
                                            isBusy
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_filled,
                                            size: 48,
                                          ),
                                          onPressed: () {
                                            if (isCurrent) {
                                              playing
                                                  ? audioHandler.pause()
                                                  : audioHandler.play();
                                            } else {
                                              _playResolvedEpisode(context, ref,
                                                  _displayEpisode);
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          : _displayEpisode.articleUrl != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.article_outlined,
                                    size: 48,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '打开文章: ${_displayEpisode.articleUrl}')),
                                    );
                                  },
                                )
                              : const SizedBox(width: 48),
                    ],
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 16, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatDuration(_displayEpisode.duration)} · ${_displayEpisode.pubDate?.year}/${_displayEpisode.pubDate?.month}/${_displayEpisode.pubDate?.day}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _generateSummary,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('总结单集'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_isSummarizing)
                  Center(
                      child: CircularProgressIndicatorM3E(
                    size: CircularProgressM3ESize.m,
                    activeColor: colorScheme.primary,
                  ))
                else if (_aiSummary != null)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Text(_aiSummary!,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AIAgentScreen(episode: _displayEpisode)),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text('与 AI 助手深度交流'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                Text('本期节目的主要内容有：',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                HtmlWidget(
                  _processDescription(_displayEpisode.description),
                  onTapUrl: (url) {
                    if (url.startsWith('seek://')) {
                      final timestamp = url.substring(7);
                      final duration = _parseTimestamp(timestamp);
                      audioHandler.seek(duration);
                      audioHandler.play();
                      return true;
                    }
                    return false;
                  },
                  customStylesBuilder: (element) {
                    return {
                      'color': colorScheme.brightness == Brightness.dark
                          ? 'white'
                          : 'black',
                      'background-color': 'transparent',
                      'font-weight': 'normal',
                    };
                  },
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.8,
                      ),
                ),
              ],
            ),
          ),
          if (_isResolving)
            Positioned.fill(
              child: Container(
                color: colorScheme.surface.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: widget.episode.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: ImageUtils.getHighResUrl(
                                      widget.episode.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.podcasts,
                                    size: 48,
                                    color: colorScheme.primary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          widget.episode.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '正在获取完整信息',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double? _calculateProgress(PlaybackState? state, MediaItem? item) {
    if (state == null ||
        item == null ||
        item.duration == null ||
        item.duration == Duration.zero) {
      return null;
    }
    return state.position.inMilliseconds / item.duration!.inMilliseconds;
  }

  String _formatDuration(String? durationStr) {
    if (durationStr == null) return '未知时长';
    try {
      if (durationStr.contains(':')) {
        final parts = durationStr.split(':');
        if (parts.length == 3) {
          final hours = int.parse(parts[0]);
          final minutes = int.parse(parts[1]);
          if (hours > 0) return '$hours小时$minutes分钟';
          return '$minutes分钟';
        } else if (parts.length == 2) {
          return '${int.parse(parts[0])}分钟';
        }
      }
      final seconds = double.tryParse(durationStr)?.toInt() ?? 0;
      if (seconds > 0) {
        final minutes = (seconds / 60).floor();
        return '$minutes分钟';
      }
    } catch (_) {}
    return durationStr;
  }

  void _playResolvedEpisode(
      BuildContext context, WidgetRef ref, Episode episode) async {
    final podcastService = ref.read(podcastServiceProvider);
    final audioHandler = ref.read(audioHandlerProvider);

    if (episode.audioUrl == null ||
        episode.audioUrl!.isEmpty ||
        episode.audioUrl!.contains('xiaoyuzhoufm.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
              SizedBox(width: 12),
              Text('正在解析小宇宙音频地址...'),
            ],
          ),
          duration: Duration(seconds: 10),
        ),
      );

      try {
        final resolved = await podcastService.resolveEpisodeUrl(episode);
        if (context.mounted)
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (resolved != null && resolved.audioUrl != null) {
          audioHandler.playEpisode(resolved);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('解析失败，请尝试搜索该播客后从列表播放')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('解析出错: $e')),
          );
        }
      }
    } else {
      audioHandler.playEpisode(episode);
    }
  }
}
