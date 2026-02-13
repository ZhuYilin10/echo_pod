import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:m3e_collection/m3e_collection.dart';
import '../../../core/providers/providers.dart';
import '../../../core/models/episode.dart';
import '../../episode_detail/episode_detail_screen.dart';
import '../../player/player_screen.dart';

class ShelfViewFavorites extends ConsumerWidget {
  const ShelfViewFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoritesNotifierProvider);

    return favAsync.when(
      data: (episodes) {
        if (episodes.isEmpty) {
          return _buildEmptyState();
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _buildFavoriteCard(context, ref, episodes[index]),
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
      error: (e, _) => SliverFillRemaining(
        child: Center(child: Text('加载失败: $e')),
      ),
    );
  }

  Widget _buildFavoriteCard(
      BuildContext context, WidgetRef ref, Episode episode) {
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
            // 封面
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 80,
                height: 80,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: episode.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: episode.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(Icons.podcasts,
                            color: Colors.grey, size: 32),
                      )
                    : const Icon(Icons.podcasts, color: Colors.grey, size: 32),
              ),
            ),
            const SizedBox(width: 16),
            // 信息区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.podcastTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (episode.hasAudio)
                        GestureDetector(
                          onTap: () => _playEpisode(context, ref, episode),
                          child: Row(
                            children: [
                              Icon(Icons.play_circle_outline,
                                  size: 16, color: Colors.grey[700]),
                              const SizedBox(width: 4),
                              Text(
                                '播放',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(favoritesNotifierProvider.notifier)
                              .toggle(episode);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.favorite,
                                size: 16, color: Color(0xFFE35D6A)),
                            const SizedBox(width: 4),
                            Text(
                              '取消收藏',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
  }

  void _playEpisode(
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
                    strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('正在解析音频地址...'),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );

      try {
        final resolved = await podcastService.resolveEpisodeUrl(episode);
        if (context.mounted)
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (resolved != null && resolved.audioUrl != null) {
          audioHandler.playEpisode(resolved);
          if (context.mounted) PlayerScreen.show(context, resolved);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('解析失败，请尝试搜索该播客后播放')),
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
      PlayerScreen.show(context, episode);
    }
  }

  Widget _buildEmptyState() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '暂无收藏内容',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
