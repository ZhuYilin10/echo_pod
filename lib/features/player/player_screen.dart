import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../../services/audio/audio_handler.dart';
import 'playlist_screen.dart';

import '../podcast_detail/podcast_detail_screen.dart';

import '../../services/web_podcast_service.dart';
import '../../services/storage/storage_service.dart';
import '../../core/utils/image_utils.dart';
import 'package:m3e_collection/m3e_collection.dart';
import '../../core/theme/theme_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const PlayerScreen({super.key, required this.episode});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();

  /// 显示播放器页面（透明背景模态）
  static Future<void> show(BuildContext context, Episode episode) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return PlayerScreen(episode: episode);
      },
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
    );
  }
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  StreamSubscription<MediaItem?>? _mediaItemSubscription;
  Episode? _currentEpisode;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioHandler = ref.read(audioHandlerProvider);
      _currentEpisode = _displayEpisode;
      _mediaItemSubscription = audioHandler.mediaItem.listen((mediaItem) {
        if (mediaItem != null && mounted) {
          setState(() {
            _currentEpisode = _getEpisodeFromMediaItem(mediaItem);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _mediaItemSubscription?.cancel();
    super.dispose();
  }

  Episode _getEpisodeFromMediaItem(MediaItem mediaItem) {
    if (mediaItem.id.startsWith('web_')) {
      return Episode(
        guid: mediaItem.id,
        title: mediaItem.title,
        podcastTitle: mediaItem.album ?? '',
        imageUrl: mediaItem.artUri?.toString(),
        audioUrl: mediaItem.id,
        podcastFeedUrl: '',
      );
    }
    return mediaItem.extras != null
        ? Episode.fromJson(mediaItem.extras!)
        : Episode(
            guid: mediaItem.id,
            title: mediaItem.title,
            podcastTitle: mediaItem.album ?? '',
            imageUrl: mediaItem.artUri?.toString(),
            audioUrl: mediaItem.id,
            podcastFeedUrl: '',
          );
  }

  Episode get _displayEpisode => _currentEpisode ?? widget.episode;
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

  void _showShownoteBottomSheet(BuildContext context) {
    final audioHandler = ref.read(audioHandlerProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayEpisode.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        HtmlWidget(
                          _processDescription(_displayEpisode.description),
                          onTapUrl: (url) {
                            if (url.startsWith('seek://')) {
                              final timestamp = url.substring(7);
                              final duration = _parseTimestamp(timestamp);
                              audioHandler.seek(duration);
                              return true;
                            }
                            return false;
                          },
                          customStylesBuilder: (element) {
                            return {
                              'font-weight': 'normal',
                              'line-height': '1.6',
                            };
                          },
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.6,
                                    fontSize: 16,
                                  ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);
    final isSubscribedAsync = ref.watch(subscriptionsProvider).whenData(
        (subs) => subs.any((p) => p.title == _displayEpisode.podcastTitle));

    return Dismissible(
      key: const Key('player_dismiss'),
      direction: DismissDirection.down,
      background: const SizedBox.shrink(),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: AppColors.ricePaper,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.expand_more,
                size: 32, color: Color(0xFF1D1D1F)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Color(0xFF1D1D1F)),
              onPressed: () => _showShownoteBottomSheet(context),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final videoState = ref.watch(videoPodcastControllerProvider);

                  // If video is "active" (meaning we have loaded a native video), show it.
                  // Note: isExpanded was used for overlay, but here we reuse it or just check videoUrl.
                  if (videoState.videoUrl != null) {
                    return Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.06),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // Video Aspect Ratio
                          child:
                              const VideoPlayerWidget(), // Reusing the widget which now returns the player
                        ),
                      ),
                    );
                  }

                  // Default Artwork
                  return Hero(
                    tag: 'episode_artwork_${_displayEpisode.guid}',
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.06),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: ImageUtils.getHighResUrl(
                                _displayEpisode.imageUrl),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.music_note,
                                  color: Colors.grey, size: 48),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Title & Channel
              // Title & Channel
              // Title & Channel
              StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    final mediaItem = snapshot.data;
                    final currentId = mediaItem?.id;
                    final isCurrent = currentId == _displayEpisode.guid;
                    final title = isCurrent
                        ? (mediaItem?.title ?? _displayEpisode.title)
                        : _displayEpisode.title;
                    final subtitle = isCurrent
                        ? (mediaItem?.album ?? _displayEpisode.podcastTitle)
                        : _displayEpisode.podcastTitle;

                    return Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1D1F)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: _navigateToPodcastDetail,
                                child: Text(
                                  subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color(0xFF007AFF), fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            isSubscribedAsync.when(
                              data: (isSubscribed) => GestureDetector(
                                onTap: isSubscribed
                                    ? null
                                    : () async {
                                        final podcastService =
                                            ref.read(podcastServiceProvider);
                                        final storageService =
                                            ref.read(storageServiceProvider);
                                        final results =
                                            await podcastService.searchPodcasts(
                                                _displayEpisode.podcastTitle);
                                        if (results.isNotEmpty) {
                                          await storageService
                                              .subscribe(results.first);
                                          ref.invalidate(subscriptionsProvider);
                                          ref.invalidate(isSubscribedProvider(
                                              results.first.feedUrl));
                                        }
                                      },
                                child: Material(
                                  color: isSubscribed
                                      ? Colors.grey[200]
                                      : AppColors.vermillion.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  child: InkWell(
                                    onTap: isSubscribed
                                        ? null
                                        : () async {
                                            final podcastService = ref
                                                .read(podcastServiceProvider);
                                            final storageService = ref
                                                .read(storageServiceProvider);
                                            final results = await podcastService
                                                .searchPodcasts(_displayEpisode
                                                    .podcastTitle);
                                            if (results.isNotEmpty) {
                                              await storageService
                                                  .subscribe(results.first);
                                              ref.invalidate(
                                                  subscriptionsProvider);
                                              ref.invalidate(
                                                  isSubscribedProvider(
                                                      results.first.feedUrl));
                                            }
                                          },
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: isSubscribed
                                                ? Colors.grey[300]!
                                                : AppColors.vermillion),
                                      ),
                                      child: Text(
                                        isSubscribed ? '已订阅' : '+ 订阅',
                                        style: TextStyle(
                                          color: isSubscribed
                                              ? Colors.grey[600]
                                              : AppColors.vermillion,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              loading: () => SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: FittedBox(
                                    child: CircularProgressIndicatorM3E(
                                      size: CircularProgressM3ESize.s,
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                    ),
                                  )),
                              error: (_, __) => const SizedBox(),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              const SizedBox(height: 24),
              // Progress Bar
              StreamBuilder<PositionData>(
                stream: _positionDataStream(audioHandler),
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final currentId = audioHandler.mediaItem.value?.id;
                  final isCurrent = currentId == _displayEpisode.guid;
                  final displayState = isCurrent ? state : null;

                  return ProgressBar(
                    progress: displayState?.position ?? Duration.zero,
                    total: displayState?.duration ?? Duration.zero,
                    buffered: displayState?.bufferedPosition ?? Duration.zero,
                    onSeek: (position) {
                      if (isCurrent) {
                        audioHandler.seek(position);
                      }
                    },
                    progressBarColor: AppColors.vermillion,
                    baseBarColor: const Color(0xFFE5E5EA),
                    thumbColor: isCurrent
                        ? AppColors.vermillion
                        : const Color(0xFFD1D1D6),
                    barHeight: 16,
                    thumbRadius: 0,
                    thumbGlowRadius: 0,
                    barCapShape: BarCapShape.round,
                    timeLabelTextStyle:
                        const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                    timeLabelLocation: TimeLabelLocation.below,
                    timeLabelPadding: 12,
                  );
                },
              ),
              const SizedBox(height: 24),
              // Playback Controls - Expressive Style
              StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rewind button
                      Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(0.05),
                        child: InkWell(
                          onTap: () => audioHandler.seek(
                              audioHandler.playbackState.value.updatePosition -
                                  const Duration(seconds: 15)),
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.replay_10,
                              size: 28,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Play/Pause button
                      Builder(
                        builder: (context) {
                          final currentId = audioHandler.mediaItem.value?.id;
                          final isCurrent = currentId == _displayEpisode.guid;
                          return Material(
                            color: AppColors.vermillion,
                            shape: const CircleBorder(),
                            elevation: 4,
                            shadowColor: AppColors.vermillion.withOpacity(0.3),
                            child: InkWell(
                              onTap: () {
                                if (isCurrent) {
                                  playing
                                      ? audioHandler.pause()
                                      : audioHandler.play();
                                } else {
                                  audioHandler.playEpisode(_displayEpisode);
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  (isCurrent && playing)
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      // Forward button
                      Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(0.05),
                        child: InkWell(
                          onTap: () => audioHandler.seek(
                              audioHandler.playbackState.value.updatePosition +
                                  const Duration(seconds: 30)),
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.forward_30,
                              size: 28,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              // Bottom Controls - Speed, Sleep Timer, Playlist
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Speed Control
                    _buildControlButton(
                      context: context,
                      child: StreamBuilder<MediaItem?>(
                        stream: audioHandler.mediaItem,
                        builder: (context, mediaSnapshot) {
                          final isCurrent =
                              mediaSnapshot.data?.id == _displayEpisode.guid;

                          if (isCurrent) {
                            return StreamBuilder<PlaybackState>(
                              stream: audioHandler.playbackState,
                              builder: (context, snapshot) {
                                final speed = snapshot.data?.speed ?? 1.0;
                                return Text(
                                  '${speed.toStringAsFixed(1)}x',
                                  style: const TextStyle(
                                    color: Color(0xFF4A4A4A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            );
                          } else {
                            return FutureBuilder<double?>(
                              future: ref
                                  .read(storageServiceProvider)
                                  .getPodcastSpeed(
                                      _displayEpisode.podcastFeedUrl),
                              builder: (context, snapshot) {
                                final speed = snapshot.data ?? 1.0;
                                return Text(
                                  '${speed.toStringAsFixed(1)}x',
                                  style: const TextStyle(
                                    color: Color(0xFF4A4A4A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      onTap: () => _showSpeedDialog(context, audioHandler),
                    ),
                    // Sleep Timer
                    _buildControlButton(
                      context: context,
                      child: StreamBuilder<Duration?>(
                        stream: audioHandler.sleepTimerStream,
                        builder: (context, snapshot) {
                          final remaining = snapshot.data;
                          return Icon(
                            Icons.timer,
                            size: 24,
                            color: remaining != null
                                ? AppColors.vermillion
                                : const Color(0xFF4A4A4A),
                          );
                        },
                      ),
                      onTap: () => _showSleepTimerDialog(context, audioHandler),
                    ),
                    // Playlist
                    _buildControlButton(
                      context: context,
                      child: const Icon(
                        Icons.playlist_play,
                        size: 28,
                        color: Color(0xFF4A4A4A),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlaylistScreen())),
                    ),
                    // Download
                    _buildDownloadControl(context),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 64,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildDownloadControl(BuildContext context) {
    if (_displayEpisode.audioUrl == null) return const SizedBox(width: 64);

    final downloadedAsync = ref.watch(downloadedEpisodesProvider);
    final activeDownloadsAsync = ref.watch(activeDownloadsProvider);

    return _buildControlButton(
      context: context,
      onTap: () {}, // Handled inside child buttons or not needed for container
      child: downloadedAsync.when(
        data: (downloadedEpisodes) {
          final isDownloaded =
              downloadedEpisodes.any((e) => e.guid == _displayEpisode.guid);

          if (isDownloaded) {
            return IconButton(
              icon: const Icon(Icons.download_done_rounded,
                  color: AppColors.vermillion, size: 24),
              onPressed: () => _handleDelete(context),
              tooltip: '已下载 (点击删除)',
            );
          }

          // Check if currently downloading
          double? progress;
          activeDownloadsAsync.whenData((active) {
            if (active.containsKey(_displayEpisode.audioUrl!)) {
              progress = active[_displayEpisode.audioUrl!];
            }
          });

          if (progress != null && progress! >= 0 && progress! < 1.0) {
            return SizedBox(
              width: 24,
              height: 24,
              child: FittedBox(
                child: CircularProgressIndicatorM3E(
                  value: progress,
                  size: CircularProgressM3ESize.s,
                  activeColor: AppColors.vermillion,
                ),
              ),
            );
          }

          return IconButton(
            icon: const Icon(Icons.download_rounded,
                color: Color(0xFF4A4A4A), size: 24),
            onPressed: _handleDownload,
            tooltip: '下载',
          );
        },
        loading: () => const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicatorM3E(
            size: CircularProgressM3ESize.s,
            activeColor: Color(0xFF4A4A4A),
          ),
        ),
        error: (_, __) =>
            const Icon(Icons.error_outline, color: Color(0xFF4A4A4A), size: 24),
      ),
    );
  }

  void _handleDownload() async {
    if (_displayEpisode.audioUrl == null) return;

    try {
      final downloadService = ref.read(downloadServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      await downloadService.downloadEpisode(_displayEpisode.audioUrl!, (p) {});

      // Save complete metadata after successful download
      await storageService.saveDownload(_displayEpisode);

      ref.invalidate(downloadedEpisodesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('下载完成')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('下载失败: $e')));
      }
    }
  }

  void _handleDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除下载'),
        content: const Text('确定要删除该单集的已下载文件吗？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true && _displayEpisode.audioUrl != null) {
      final downloadService = ref.read(downloadServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      await downloadService.deleteDownload(_displayEpisode.audioUrl!);
      await storageService.removeDownload(_displayEpisode.guid);

      ref.invalidate(downloadedEpisodesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('已删除')));
      }
    }
  }

  Stream<PositionData> _positionDataStream(EchoPodAudioHandler audioHandler) {
    return Rx.combineLatest3<PlaybackState, MediaItem?, void, PositionData>(
        audioHandler.playbackState,
        audioHandler.mediaItem,
        Stream.periodic(const Duration(milliseconds: 500)),
        (playbackState, mediaItem, _) {
      return PositionData(
        playbackState.position,
        playbackState.bufferedPosition,
        mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  Future<void> _showSpeedDialog(
      BuildContext context, EchoPodAudioHandler audioHandler) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FutureBuilder<double?>(
            future: ref
                .read(storageServiceProvider)
                .getPodcastSpeed(_displayEpisode.podcastFeedUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 200,
                    child: Center(
                        child: CircularProgressIndicatorM3E(
                      size: CircularProgressM3ESize.m,
                      activeColor: Color(0xFF007AFF),
                    )));
              }
              final savedSpeed = snapshot.data;
              final currentSpeed = audioHandler.playbackState.value.speed;
              return _SpeedDialogBottomSheet(
                initialSpeed: currentSpeed,
                savedSpeed: savedSpeed,
                feedUrl: _displayEpisode.podcastFeedUrl,
                targetGuid: _displayEpisode.guid,
                audioHandler: audioHandler,
                storageService: ref.read(storageServiceProvider),
              );
            });
      },
    );
    if (mounted) setState(() {});
  }

  void _showSleepTimerDialog(
      BuildContext context, EchoPodAudioHandler audioHandler) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('定时关闭',
                    style: TextStyle(
                        color: Color(0xFF1D1D1F),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('关闭',
                    style: TextStyle(color: Color(0xFF1D1D1F))),
                onTap: () {
                  audioHandler.setSleepTimer(null);
                  Navigator.pop(context);
                },
              ),
              ...[15, 30, 45, 60].map((mins) => ListTile(
                    title: Text('$mins 分钟后',
                        style: const TextStyle(color: Color(0xFF1D1D1F))),
                    onTap: () {
                      audioHandler.setSleepTimer(Duration(minutes: mins));
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  PositionData(this.position, this.bufferedPosition, this.duration);
}

class _SpeedDialogBottomSheet extends StatefulWidget {
  final double initialSpeed;
  final double? savedSpeed;
  final String feedUrl;
  final String targetGuid;
  final EchoPodAudioHandler audioHandler;
  final StorageService storageService;

  const _SpeedDialogBottomSheet({
    required this.initialSpeed,
    required this.savedSpeed,
    required this.feedUrl,
    required this.targetGuid,
    required this.audioHandler,
    required this.storageService,
  });

  @override
  State<_SpeedDialogBottomSheet> createState() =>
      _SpeedDialogBottomSheetState();
}

class _SpeedDialogBottomSheetState extends State<_SpeedDialogBottomSheet> {
  late double currentSpeed;
  late bool overrideChannel;

  @override
  void initState() {
    super.initState();
    currentSpeed = widget.initialSpeed;
    // logic: if we have a saved speed and it matches current, switch is ON.
    if (widget.savedSpeed != null &&
        (widget.savedSpeed! - currentSpeed).abs() < 0.01) {
      overrideChannel = true;
    } else {
      overrideChannel = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('播放倍速',
                style: TextStyle(
                    color: Color(0xFF1D1D1F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Text('0.5x', style: TextStyle(color: Color(0xFF8E8E93))),
                Expanded(
                  child: Slider(
                    value: currentSpeed.clamp(0.5, 3.0),
                    min: 0.5,
                    max: 3.0,
                    divisions: 25, // 0.1 step increments
                    activeColor: AppColors.vermillion,
                    inactiveColor: const Color(0xFFE5E5EA),
                    onChanged: (val) {
                      final newSpeed = double.parse(val.toStringAsFixed(1));
                      if (newSpeed != currentSpeed) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          currentSpeed = newSpeed;
                          // Do NOT disconnect channel override if manually changed.
                          // Instead, if override is ON, update the saved preference immediately.
                          if (overrideChannel) {
                            widget.storageService
                                .savePodcastSpeed(widget.feedUrl, currentSpeed);
                          }
                        });

                        // Only update AudioHandler if this is the currently playing item
                        if (widget.audioHandler.mediaItem.value?.id ==
                            widget.targetGuid) {
                          print(
                              '[SpeedLog] SpeedDialog: Slider changed to $currentSpeed. Updating active playback.');
                          widget.audioHandler.setSpeed(currentSpeed);
                        } else {
                          print(
                              '[SpeedLog] SpeedDialog: Slider changed to $currentSpeed. NOT updating active playback.');
                        }
                      }
                    },
                  ),
                ),
                const Text('3.0x', style: TextStyle(color: Color(0xFF8E8E93))),
              ],
            ),
          ),
          Text(
            '${currentSpeed.toStringAsFixed(1)}x',
            style: const TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('应用于该频道',
                style: TextStyle(color: Color(0xFF1D1D1F), fontSize: 14)),
            subtitle: const Text('以后该频道的所有节目都按此倍速播放',
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
            value: overrideChannel,
            activeColor: AppColors.vermillion,
            onChanged: (val) {
              print(
                  '[SpeedLog] SpeedDialog: "Apply to Channel" switched to $val');
              setState(() => overrideChannel = val);
              if (val) {
                widget.storageService
                    .savePodcastSpeed(widget.feedUrl, currentSpeed);
              } else {
                widget.storageService.removePodcastSpeed(widget.feedUrl);
              }
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vermillion,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('确定'),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
