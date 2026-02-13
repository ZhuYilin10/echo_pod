import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/providers.dart';
import '../../../core/theme/theme_config.dart';
import '../../player/player_screen.dart';

/// 全局浮动 Mini Player — 显示在 CNTabBar 上方
class FloatingMiniPlayer extends ConsumerWidget {
  const FloatingMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        if (mediaItem == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            final episode = audioHandler.currentEpisode;
            if (episode != null && context.mounted) {
              PlayerScreen.show(context, episode);
            }
          },
          child: Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.vermillion.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, playbackSnapshot) {
                  final duration = mediaItem.duration ?? Duration.zero;
                  final position =
                      playbackSnapshot.data?.updatePosition ?? Duration.zero;
                  final progress = duration.inMilliseconds > 0
                      ? (position.inMilliseconds / duration.inMilliseconds)
                          .clamp(0.0, 1.0)
                      : 0.0;
                  final playing = playbackSnapshot.data?.playing ?? false;

                  return Stack(
                    children: [
                      // 背景色进度（从左到右填充）
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.vermillion.withOpacity(0.20),
                          ),
                        ),
                      ),
                      // 主内容行
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          children: [
                            // 小封面
                            Hero(
                              tag: 'mini_player_artwork',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: mediaItem.artUri != null
                                      ? CachedNetworkImage(
                                          imageUrl: mediaItem.artUri.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              _defaultArt(),
                                        )
                                      : _defaultArt(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // 标题 + 节目名
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mediaItem.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1D1D1F),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    '${mediaItem.album ?? ''}  ${_formatTime(position)}/${_formatTime(duration)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            // 播放/暂停按钮
                            GestureDetector(
                              onTap: () {
                                if (playing) {
                                  audioHandler.pause();
                                } else {
                                  audioHandler.play();
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.vermillion,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.vermillion.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  playing ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0)
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Widget _defaultArt() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9966), Color(0xFF4A7C59)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.white70, size: 20),
      ),
    );
  }
}
