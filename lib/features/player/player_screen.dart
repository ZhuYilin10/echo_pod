import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../../services/audio/audio_handler.dart';
import 'playlist_screen.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const PlayerScreen({super.key, required this.episode});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF001F1F), // Dark teal background from screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.expand_more, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.ios_share_rounded), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const Spacer(),
            // Large Artwork
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, offset: const Offset(0, 20))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.episode.imageUrl ?? '',
                  width: double.infinity,
                  aspectRatio: 1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Title & Channel
            Text(
              widget.episode.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.episode.podcastTitle,
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('+ 订阅', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Spacer(),
            // Custom Progress Bar (Waveform style placeholder or linear)
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
                );
              },
            ),
            const SizedBox(height: 40),
            // Playback Controls
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.radio_outlined, color: Colors.grey),
                    IconButton(
                      icon: const Icon(Icons.replay_15, size: 36, color: Colors.white),
                      onPressed: () => audioHandler.seek(audioHandler.playbackState.value.updatePosition - const Duration(seconds: 15)),
                    ),
                    IconButton(
                      iconSize: 84,
                      icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white),
                      onPressed: playing ? audioHandler.pause : audioHandler.play,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_30, size: 36, color: Colors.white),
                      onPressed: () => audioHandler.seek(audioHandler.playbackState.value.updatePosition + const Duration(seconds: 30)),
                    ),
                    const Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            // Bottom Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.info_outline, color: Colors.grey),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaylistScreen())),
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_play, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('播放列表', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.comment_outlined, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 32),
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
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  PositionData(this.position, this.bufferedPosition, this.duration);
}
