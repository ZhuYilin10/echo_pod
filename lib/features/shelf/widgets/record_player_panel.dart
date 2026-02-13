import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../../core/providers/providers.dart';
import '../../player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/image_utils.dart';

/// 唱片播放面板组件
class RecordPlayerPanel extends ConsumerWidget {
  const RecordPlayerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final mediaItem = mediaSnapshot.data;

        return GestureDetector(
          onTap: () {
            // 直接使用全局的 currentEpisode
            final episode = audioHandler.currentEpisode;

            if (episode != null && context.mounted) {
              PlayerScreen.show(context, episode);
            }
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A6B5), // 桃红色
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 封面区域（带叠加信息）
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      // 封面图片
                      Hero(
                        tag: 'episode_artwork_${mediaItem?.id ?? "unknown"}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: AspectRatio(
                            aspectRatio: 1.6, // 增大比例，让高度更矮
                            child: mediaItem?.artUri != null
                                ? CachedNetworkImage(
                                    imageUrl: ImageUtils.getHighResUrl(
                                        mediaItem!.artUri.toString()),
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) =>
                                        _buildDefaultCover(),
                                  )
                                : _buildDefaultCover(),
                          ),
                        ),
                      ),

                      // 底部叠加信息
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.75),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.25),
                                Colors.black.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.3, 0.6, 1.0],
                            ),
                          ),
                          child: Text(
                            mediaItem?.album ?? '未在播放',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 单集信息和播放按钮
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mediaItem?.title ?? '未在播放',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A2C3E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            StreamBuilder<PlaybackState>(
                              stream: audioHandler.playbackState,
                              builder: (context, playbackSnapshot) {
                                final duration =
                                    mediaItem?.duration ?? Duration.zero;
                                final position =
                                    playbackSnapshot.data?.updatePosition ??
                                        Duration.zero;
                                final remaining = duration - position;

                                return Text(
                                  '剩余 ${_formatDuration(remaining)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6A4C5E), // 比标题浅但更易读
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      StreamBuilder<PlaybackState>(
                        stream: audioHandler.playbackState,
                        builder: (context, playbackSnapshot) {
                          final playing =
                              playbackSnapshot.data?.playing ?? false;

                          return Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4A2C3E),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              iconSize: 32,
                              onPressed: () {
                                if (playing) {
                                  audioHandler.pause();
                                } else {
                                  audioHandler.play();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF9966),
            Color(0xFF4A7C59),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.album,
          size: 80,
          color: Colors.white24,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours 小时 $minutes 分钟';
    } else if (minutes > 0) {
      return '$minutes 分钟';
    } else {
      return '${duration.inSeconds} 秒';
    }
  }
}
