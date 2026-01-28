import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../../services/audio/audio_handler.dart';
import 'playlist_screen.dart';
import '../share/share_screen.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const PlayerScreen({super.key, required this.episode});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _isSkipSilenceEnabled = false;

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

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
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShareScreen(episode: widget.episode)),
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
            Hero(
              tag: 'episode_artwork_${widget.episode.guid}',
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
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
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title & Channel
            Text(
              widget.episode.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.episode.podcastTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.tealAccent),
                  ),
                  child: const Text(
                    '+ 订阅',
                    style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Extra Controls (Speed, Sleep Timer, Skip Silence)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Speed Control
                  StreamBuilder<PlaybackState>(
                    stream: audioHandler.playbackState,
                    builder: (context, snapshot) {
                      final speed = snapshot.data?.speed ?? 1.0;
                      return TextButton(
                        onPressed: () {
                          final nextSpeed = speed >= 2.0 ? 0.5 : speed + 0.5;
                          audioHandler.setSpeed(nextSpeed);
                        },
                        child: Text(
                          '${speed}x',
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      );
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
                              color: remaining != null ? Colors.tealAccent : Colors.white70,
                            ),
                            if (remaining != null)
                              Text(
                                '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: const TextStyle(color: Colors.tealAccent, fontSize: 10),
                              ),
                          ],
                        ),
                        onPressed: () => _showSleepTimerDialog(context, audioHandler),
                      );
                    },
                  ),
                  // Skip Silence
                  IconButton(
                    icon: Icon(
                      Icons.volume_off_outlined,
                      color: _isSkipSilenceEnabled ? Colors.tealAccent : Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSkipSilenceEnabled = !_isSkipSilenceEnabled;
                      });
                      audioHandler.setSkipSilence(_isSkipSilenceEnabled);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Progress Bar
            StreamBuilder<PositionData>(
              stream: _positionDataStream(audioHandler),
              builder: (context, snapshot) {
                final state = snapshot.data;
                return ProgressBar(
                  progress: state?.position ?? Duration.zero,
                  total: state?.duration ?? Duration.zero,
                  buffered: state?.bufferedPosition ?? Duration.zero,
                  onSeek: audioHandler.seek,
                  progressBarColor: Colors.white,
                  baseBarColor: Colors.white.withOpacity(0.2),
                  thumbColor: Colors.white,
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
                      icon: const Icon(Icons.replay_10, size: 36, color: Colors.white),
                      onPressed: () => audioHandler.seek(audioHandler.playbackState.value.updatePosition - const Duration(seconds: 15)),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      iconSize: 72,
                      icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white),
                      onPressed: playing ? audioHandler.pause : audioHandler.play,
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.forward_30, size: 36, color: Colors.white),
                      onPressed: () => audioHandler.seek(audioHandler.playbackState.value.updatePosition + const Duration(seconds: 30)),
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
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaylistScreen())),
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
        Stream.periodic(const Duration(milliseconds: 200)),
        (playbackState, mediaItem, _) {
      Duration position = playbackState.updatePosition;
      if (playbackState.playing) {
        final now = DateTime.now();
        final elapsed = now.difference(playbackState.updateTime);
        position += elapsed * playbackState.speed;
      }
      return PositionData(
        position,
        playbackState.bufferedPosition,
        mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _showSleepTimerDialog(BuildContext context, EchoPodAudioHandler audioHandler) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('定时关闭', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('关闭', style: TextStyle(color: Colors.white)),
                onTap: () {
                  audioHandler.setSleepTimer(null);
                  Navigator.pop(context);
                },
              ),
              ...[15, 30, 45, 60].map((mins) => ListTile(
                title: Text('$mins 分钟后', style: const TextStyle(color: Colors.white)),
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
