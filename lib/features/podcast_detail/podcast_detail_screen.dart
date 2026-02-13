import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/podcast.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../episode_detail/episode_detail_screen.dart';
import 'package:audio_service/audio_service.dart'; // Import for PlaybackState and MediaItem
import 'package:m3e_collection/m3e_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/utils/image_utils.dart';

class PodcastDetailScreen extends ConsumerStatefulWidget {
  final Podcast podcast;

  const PodcastDetailScreen({super.key, required this.podcast});

  @override
  ConsumerState<PodcastDetailScreen> createState() =>
      _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends ConsumerState<PodcastDetailScreen> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  List<Episode> _allEpisodes = [];
  final List<Episode> _displayedEpisodes = [];
  bool _isLoading = true;
  bool _isPaginating = false;
  bool _isAscending = false;
  bool _isAppBarCollapsed = false; // 追踪AppBar是否收起
  static const int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();
  final Map<String, double> _downloadProgress = {};

  @override
  void initState() {
    super.initState();
    _loadEpisodes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
      _allEpisodes = _allEpisodes.reversed.toList();
      _refreshUI();
    });
  }

  void _onScroll() {
    // 检查AppBar是否收起 (250是expandedHeight)
    final isCollapsed = _scrollController.hasClients &&
        _scrollController.offset > (250 - kToolbarHeight);
    if (isCollapsed != _isAppBarCollapsed) {
      setState(() => _isAppBarCollapsed = isCollapsed);
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isPaginating && _displayedEpisodes.length < _allEpisodes.length) {
        _loadMore();
      }
    }
  }

  void _loadMore() async {
    if (_isPaginating) return;
    setState(() => _isPaginating = true);

    // Simulate minor delay for smoother UX
    await Future.delayed(const Duration(milliseconds: 300));

    final startIndex = _displayedEpisodes.length;
    final endIndex = (startIndex + _pageSize).clamp(0, _allEpisodes.length);

    if (startIndex < endIndex) {
      for (int i = startIndex; i < endIndex; i++) {
        _displayedEpisodes.add(_allEpisodes[i]);
        _listKey.currentState?.insertItem(i);
      }
    }

    setState(() => _isPaginating = false);
  }

  void _loadEpisodes({bool incremental = false}) async {
    final service = ref.read(podcastServiceProvider);
    final episodes = await service.fetchEpisodes(widget.podcast.feedUrl);

    if (mounted) {
      if (incremental && _allEpisodes.isNotEmpty) {
        // Simple data refresh
        _allEpisodes = episodes;
        _refreshUI();
      } else {
        _allEpisodes = episodes;
        _refreshUI();
      }
    }
  }

  void _refreshUI() {
    // Logic to reset the display list
    setState(() {
      _displayedEpisodes.clear();
      final count = _pageSize.clamp(0, _allEpisodes.length);
      for (int i = 0; i < count; i++) {
        _displayedEpisodes.add(_allEpisodes[i]);
      }
      _isLoading = false;
    });
  }

  void _download(Episode episode) async {
    if (episode.audioUrl == null) return;
    setState(() => _downloadProgress[episode.guid] = 0.01);

    final downloadService = ref.read(downloadServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    try {
      await downloadService.downloadEpisode(episode.audioUrl!, (progress) {
        if (mounted) setState(() => _downloadProgress[episode.guid] = progress);
      });
      // Save to registry
      await storageService.saveDownload(episode);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('已下载: ${episode.title}')));
        ref.invalidate(downloadedEpisodesProvider);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _downloadProgress.remove(episode.guid));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('下载失败')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubscribedAsync =
        ref.watch(isSubscribedProvider(widget.podcast.feedUrl));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadEpisodes(incremental: true);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.podcast.title,
                    style: TextStyle(
                        color:
                            _isAppBarCollapsed ? Colors.black : Colors.white)),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                collapseMode: CollapseMode.pin,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.podcast.imageUrl != null &&
                        widget.podcast.imageUrl!.isNotEmpty)
                      CachedNetworkImage(
                          imageUrl: ImageUtils.getHighResUrl(
                              widget.podcast.imageUrl!),
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                                color: Colors.indigo.shade900,
                                child: const Icon(Icons.podcasts,
                                    size: 80, color: Colors.white24),
                              ))
                    else
                      Container(
                        color: Colors.indigo.shade900,
                        child: const Icon(Icons.podcasts,
                            size: 80, color: Colors.white24),
                      ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.podcast.artist ?? '',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text('${_allEpisodes.length} 剧集',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        isSubscribedAsync.when(
                          data: (isSubscribed) => ElevatedButton(
                            onPressed: () async {
                              final storage = ref.read(storageServiceProvider);
                              if (isSubscribed) {
                                await storage
                                    .unsubscribe(widget.podcast.feedUrl);
                              } else {
                                await storage.subscribe(widget.podcast);
                              }
                              ref.invalidate(subscriptionsProvider);
                              ref.invalidate(
                                  isSubscribedProvider(widget.podcast.feedUrl));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSubscribed
                                  ? Colors.grey[800]
                                  : Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(isSubscribed ? '已订阅' : '订阅'),
                          ),
                          loading: () => CircularProgressIndicatorM3E(
                            size: CircularProgressM3ESize.s,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('剧集列表',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(_isAscending
                              ? Icons.sort_by_alpha_rounded
                              : Icons.sort_rounded),
                          tooltip: _isAscending ? '正序' : '倒序',
                          onPressed: _toggleSort,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicatorM3E(
                            size: CircularProgressM3ESize.m,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ))))
            else
              SliverAnimatedList(
                key: _listKey,
                initialItemCount: _displayedEpisodes.length,
                itemBuilder: (context, index, animation) {
                  final episode = _displayedEpisodes[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: _buildEpisodeTile(context, episode),
                  );
                },
              ),
            if (_isPaginating)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                      child: CircularProgressIndicatorM3E(
                    size: CircularProgressM3ESize.s,
                    activeColor: Theme.of(context).colorScheme.primary,
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeTile(BuildContext context, Episode episode) {
    final progress = _downloadProgress[episode.guid];
    return ListTile(
      title: Text(episode.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        episode.pubDate != null
            ? '${episode.pubDate!.year}-${episode.pubDate!.month}-${episode.pubDate!.day}'
            : '',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      leading: Hero(
        tag: 'episode_artwork_${episode.guid}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: (episode.imageUrl != null && episode.imageUrl!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: ImageUtils.getHighResUrl(episode.imageUrl!),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[800],
                        child: const Icon(Icons.podcasts, size: 24),
                      ))
              : Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[800],
                  child: const Icon(Icons.podcasts, size: 24),
                ),
        ),
      ),
      trailing: episode.hasAudio
          ? StreamBuilder<MediaItem?>(
              stream: ref.watch(audioHandlerProvider).mediaItem,
              builder: (context, mediaSnapshot) {
                final currentMediaItem = mediaSnapshot.data;
                final isSameEpisode = currentMediaItem?.id == episode.guid;

                return StreamBuilder<PlaybackState>(
                    stream: ref.watch(audioHandlerProvider).playbackState,
                    builder: (context, playbackSnapshot) {
                      final playing = playbackSnapshot.data?.playing ?? false;
                      final isPlayingThis = isSameEpisode && playing;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.playlist_add_rounded,
                                size: 24),
                            onPressed: () {
                              final handler = ref.read(audioHandlerProvider);
                              handler.addQueueItem(MediaItem(
                                id: episode.guid,
                                album: episode.podcastTitle,
                                title: episode.title,
                                artUri: episode.imageUrl != null
                                    ? Uri.parse(episode.imageUrl!)
                                    : null,
                                extras: episode.toJson(),
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('已加入播放列表'),
                                    duration: Duration(seconds: 1)),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isPlayingThis
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              size: 28,
                            ),
                            color: Colors.indigoAccent,
                            onPressed: () {
                              final handler = ref.read(audioHandlerProvider);
                              if (isSameEpisode) {
                                if (playing) {
                                  handler.pause();
                                } else {
                                  handler.play();
                                }
                              } else {
                                handler.playEpisode(episode);
                              }
                            },
                          ),
                        ],
                      );
                    });
              })
          : episode.articleUrl != null
              ? IconButton(
                  icon: Icon(
                    Icons.article_outlined,
                    size: 28,
                    color: Colors.indigoAccent,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('打开文章: ${episode.articleUrl}')),
                    );
                  },
                )
              : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EpisodeDetailScreen(episode: episode)),
        );
      },
    );
  }
}
