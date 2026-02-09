import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../player/mini_player.dart';

class ShelfViewFreshRss extends ConsumerWidget {
  const ShelfViewFreshRss({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(freshrssEpisodesProvider);

    return episodesAsync.when(
      data: (episodes) {
        if (episodes.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('没有找到 FreshRSS 内容，请先登录同步')),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final episode = episodes[index];
              return ListTile(
                leading: const Icon(Icons.podcast),
                title: Text(episode.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(episode.podcastTitle),
                trailing: const Icon(Icons.play_circle_outline),
                onTap: () {
                  // TODO: Play episode
                },
              );
            },
            childCount: episodes.length,
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SliverFillRemaining(
        child: Center(child: Text('加载失败: $e')),
      ),
    );
  }
}
