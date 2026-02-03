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
import '../share/share_screen.dart';
import '../episode_detail/episode_detail_screen.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../common/download_button.dart';
import '../../services/web_podcast_service.dart';
import '../../services/storage/storage_service.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const PlayerScreen({super.key, required this.episode});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  void _navigateToPodcastDetail() async {
    final podcastService = ref.read(podcastServiceProvider);
    final subs = await ref.read(subscriptionsProvider.future);
    final existing =
        subs.where((p) => p.title == widget.episode.podcastTitle).firstOrNull;

    if (existing != null) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PodcastDetailScreen(podcast: existing)));
      }
    } else {
      final results =
          await podcastService.searchPodcasts(widget.episode.podcastTitle);
      if (results.isNotEmpty && mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PodcastDetailScreen(podcast: results.first)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);
    final isSubscribedAsync = ref.watch(subscriptionsProvider).whenData(
        (subs) => subs.any((p) => p.title == widget.episode.podcastTitle));

    return Scaffold(
      backgroundColor: const Color(0xFF001F1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.expand_more, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EpisodeDetailScreen(episode: widget.episode)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShareScreen(episode: widget.episode)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Large Artwork with Hero
            // Large Artwork or Video Player
            // We use a Consumer to watch the video controller state.
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
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
                  tag: 'episode_artwork_${widget.episode.guid}',
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          widget.episode.imageUrl ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[900],
                            child: const Icon(Icons.music_note,
                                color: Colors.white54, size: 48),
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
                  final isCurrent = currentId == widget.episode.guid;
                  final title = isCurrent
                      ? (mediaItem?.title ?? widget.episode.title)
                      : widget.episode.title;
                  final subtitle = isCurrent
                      ? (mediaItem?.album ?? widget.episode.podcastTitle)
                      : widget.episode.podcastTitle;

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
                            color: Colors.white),
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
                                    color: Colors.tealAccent, fontSize: 14),
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
                                              widget.episode.podcastTitle);
                                      if (results.isNotEmpty) {
                                        await storageService
                                            .subscribe(results.first);
                                        ref.invalidate(subscriptionsProvider);
                                        ref.invalidate(isSubscribedProvider(
                                            results.first.feedUrl));
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSubscribed
                                      ? Colors.white10
                                      : Colors.tealAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: isSubscribed
                                          ? Colors.white24
                                          : Colors.tealAccent),
                                ),
                                child: Text(
                                  isSubscribed ? '已订阅' : '+ 订阅',
                                  style: TextStyle(
                                    color: isSubscribed
                                        ? Colors.white54
                                        : Colors.tealAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            loading: () => const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                            error: (_, __) => const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
            const Spacer(),
            // Extra Controls (Speed, Sleep Timer, Skip Silence)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Speed Control
                  StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, mediaSnapshot) {
                      final isCurrent =
                          mediaSnapshot.data?.id == widget.episode.guid;

                      if (isCurrent) {
                        // If current, use real-time playback state
                        return StreamBuilder<PlaybackState>(
                          stream: audioHandler.playbackState,
                          builder: (context, snapshot) {
                            final speed = snapshot.data?.speed ?? 1.0;
                            return TextButton(
                              onPressed: () =>
                                  _showSpeedDialog(context, audioHandler),
                              child: Text(
                                '${speed}x',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        );
                      } else {
                        // If not current, show saved preference or default
                        return FutureBuilder<double?>(
                          future: ref
                              .read(storageServiceProvider)
                              .getPodcastSpeed(widget.episode.podcastFeedUrl),
                          builder: (context, snapshot) {
                            final speed = snapshot.data ?? 1.0;
                            return TextButton(
                              onPressed: () =>
                                  _showSpeedDialog(context, audioHandler),
                              child: Text(
                                '${speed}x',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  // Sleep Timer
                  StreamBuilder<Duration?>(
                    stream: audioHandler.sleepTimerStream,
                    builder: (context, snapshot) {
                      final remaining = snapshot.data;
                      return IconButton(
                        icon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: remaining != null
                                  ? Colors.tealAccent
                                  : Colors.white70,
                            ),
                            if (remaining != null)
                              Text(
                                '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                    color: Colors.tealAccent, fontSize: 10),
                              ),
                          ],
                        ),
                        onPressed: () =>
                            _showSleepTimerDialog(context, audioHandler),
                      );
                    },
                  ),
                  // Skip Silence
                  StreamBuilder<bool>(
                      stream: audioHandler.skipSilenceStream,
                      builder: (context, snapshot) {
                        final isEnabled = snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(
                            Icons.volume_off_outlined,
                            color:
                                isEnabled ? Colors.tealAccent : Colors.white70,
                          ),
                          onPressed: () {
                            audioHandler.setSkipSilence(!isEnabled);
                          },
                        );
                      }),
                  // Download Button
                  DownloadButton(
                      episode: widget.episode, color: Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Time Saved Display
            StreamBuilder<Duration>(
              stream: audioHandler.totalTimeSavedStream,
              builder: (context, snapshot) {
                final saved = snapshot.data ?? Duration.zero;
                if (saved == Duration.zero) return const SizedBox.shrink();
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '智能跳过已为您节省了 ${_formatDurationSaved(saved)}',
                    style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Progress Bar
            StreamBuilder<PositionData>(
              stream: _positionDataStream(audioHandler),
              builder: (context, snapshot) {
                final state = snapshot.data;
                final currentId = audioHandler.mediaItem.value?.id;
                final isCurrent = currentId == widget.episode.guid;
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
                  progressBarColor: Colors.white,
                  baseBarColor: Colors.white.withOpacity(0.2),
                  thumbColor: isCurrent ? Colors.white : Colors.white24,
                  barHeight: 4,
                  thumbRadius: 6,
                  timeLabelTextStyle: const TextStyle(color: Colors.white70),
                );
              },
            ),
            const SizedBox(height: 24),
            // Playback Controls
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10,
                          size: 36, color: Colors.white),
                      onPressed: () => audioHandler.seek(
                          audioHandler.playbackState.value.updatePosition -
                              const Duration(seconds: 15)),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      iconSize: 72,
                      icon: Builder(
                        builder: (context) {
                          final currentId = audioHandler.mediaItem.value?.id;
                          final isCurrent = currentId == widget.episode.guid;
                          return Icon(
                              (isCurrent && playing)
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white);
                        },
                      ),
                      onPressed: () {
                        final currentId = audioHandler.mediaItem.value?.id;
                        final isCurrent = currentId == widget.episode.guid;
                        if (isCurrent) {
                          playing ? audioHandler.pause() : audioHandler.play();
                        } else {
                          audioHandler.playEpisode(widget.episode);
                        }
                      },
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.forward_30,
                          size: 36, color: Colors.white),
                      onPressed: () => audioHandler.seek(
                          audioHandler.playbackState.value.updatePosition +
                              const Duration(seconds: 30)),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            // Bottom Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlaylistScreen())),
                  child: const Row(
                    children: [
                      Icon(Icons.playlist_play, color: Colors.white54),
                      SizedBox(width: 4),
                      Text('播放列表', style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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

  String _formatDurationSaved(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}分${duration.inSeconds % 60}秒';
    }
    return '${duration.inSeconds}秒';
  }

  Future<void> _showSpeedDialog(
      BuildContext context, EchoPodAudioHandler audioHandler) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FutureBuilder<double?>(
            future: ref
                .read(storageServiceProvider)
                .getPodcastSpeed(widget.episode.podcastFeedUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()));
              }
              final savedSpeed = snapshot.data;
              final currentSpeed = audioHandler.playbackState.value.speed;
              return _SpeedDialogBottomSheet(
                initialSpeed: currentSpeed,
                savedSpeed: savedSpeed,
                feedUrl: widget.episode.podcastFeedUrl,
                targetGuid: widget.episode.guid,
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
      backgroundColor: const Color(0xFF1A1A1A),
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
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('关闭', style: TextStyle(color: Colors.white)),
                onTap: () {
                  audioHandler.setSleepTimer(null);
                  Navigator.pop(context);
                },
              ),
              ...[15, 30, 45, 60].map((mins) => ListTile(
                    title: Text('$mins 分钟后',
                        style: const TextStyle(color: Colors.white)),
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Text('0.5x', style: TextStyle(color: Colors.white54)),
                Expanded(
                  child: Slider(
                    value: currentSpeed.clamp(0.5, 3.0),
                    min: 0.5,
                    max: 3.0,
                    divisions: 25, // 0.1 step increments
                    activeColor: Colors.tealAccent,
                    inactiveColor: Colors.white10,
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
                const Text('3.0x', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          Text(
            '${currentSpeed.toStringAsFixed(1)}x',
            style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('应用于该频道',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            subtitle: const Text('以后该频道的所有节目都按此倍速播放',
                style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: overrideChannel,
            activeColor: Colors.tealAccent,
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
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
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
