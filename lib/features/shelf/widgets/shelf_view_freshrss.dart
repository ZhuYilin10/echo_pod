import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/providers.dart';
import '../../player/mini_player.dart';

class ShelfViewFreshRss extends ConsumerWidget {
  const ShelfViewFreshRss({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(freshrssEpisodesProvider);
    final subscriptionsAsync = ref.watch(freshrssSubscriptionsProvider);

    return SliverMainAxisGroup(
      slivers: [
        if (subscriptionsAsync.valueOrNull != null &&
            subscriptionsAsync.valueOrNull!.isNotEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subscriptionsAsync.valueOrNull!.length,
                itemBuilder: (context, index) {
                  final sub = subscriptionsAsync.valueOrNull![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: sub.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: sub.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.rss_feed),
                                )
                              : const Icon(Icons.rss_feed),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            sub.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        episodesAsync.when(
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
                    leading: episode.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: episode.imageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.podcasts),
                            ),
                          )
                        : const Icon(Icons.podcasts),
                    title: Text(episode.title,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(episode.podcastTitle),
                    trailing: const Icon(Icons.play_circle_outline),
                    onTap: () {
                      ref.read(audioHandlerProvider).playEpisode(episode);
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
        ),
      ],
    );
  }
}
