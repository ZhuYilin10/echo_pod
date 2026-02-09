import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:m3e_collection/m3e_collection.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/models/episode.dart';
import '../../episode_detail/episode_detail_screen.dart';

class ShelfViewRecentEpisodes extends ConsumerWidget {
  const ShelfViewRecentEpisodes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentEpisodesAsync = ref.watch(unifiedRecentEpisodesProvider);

    return recentEpisodesAsync.when(
      data: (episodes) {
        if (episodes.isEmpty) {
          return _buildEmptyStateSliver();
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final episode = episodes[index];
              return _buildEpisodeCard(context, ref, episode);
            },
            childCount: episodes.length,
          ),
        );
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicatorM3E(
            size: CircularProgressM3ESize.m,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(child: Text('加载失败: $error')),
      ),
    );
  }

  Widget _buildEpisodeCard(
      BuildContext context, WidgetRef ref, Episode episode) {
    final audioHandler = ref.watch(audioHandlerProvider);
    final savedPositionFuture =
        ref.watch(storageServiceProvider).getPosition(episode.guid);

    return FutureBuilder<Duration>(
      future: savedPositionFuture,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = episode.duration != null
            ? Duration(seconds: int.tryParse(episode.duration!) ?? 0)
            : Duration.zero;
        final remaining = duration - position;
        final progress = duration.inSeconds > 0
            ? position.inSeconds / duration.inSeconds
            : 0.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodeDetailScreen(episode: episode),
                ),
              );
            },
            child: Row(
              children: [
                // 封面图片
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: episode.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: episode.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(
                                Icons.podcasts,
                                color: Colors.grey,
                                size: 32),
                          )
                        : const Icon(Icons.podcasts,
                            color: Colors.grey, size: 32),
                  ),
                ),
                const SizedBox(width: 16),

                // 信息区域
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 日期和播客名
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(episode.pubDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              episode.podcastTitle,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // 标题
                      Text(
                        episode.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // 进度条
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFD4AF37)),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 播放控制和剩余时间
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              audioHandler.playEpisode(episode);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.play_circle_outline,
                                    size: 16, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Text(
                                  progress > 0 ? '继续播放' : '立即播放',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (duration.inSeconds > 0)
                            Text(
                              '剩余 ${_formatDuration(remaining)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes < 60) {
      return '$minutes分钟';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours小时$remainingMinutes分钟';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.year}-${date.month}-${date.day}';
    }
  }

  Widget _buildEmptyStateSliver() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '过去 7 天暂无新动态',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
