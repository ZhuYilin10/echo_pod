import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../episode_detail/episode_detail_screen.dart';
import 'package:m3e_collection/m3e_collection.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(playHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('播放历史'),
        centerTitle: true,
      ),
      body: historyAsync.when(
        data: (episodes) {
          if (episodes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('暂无播放记录', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    episode.imageUrl ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
                  ),
                ),
                title: Text(episode.title,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(episode.podcastTitle,
                    style: Theme.of(context).textTheme.bodySmall),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EpisodeDetailScreen(episode: episode)),
                  );
                },
              );
            },
          );
        },
        loading: () => Center(
            child: CircularProgressIndicatorM3E(
          size: CircularProgressM3ESize.m,
          activeColor: Theme.of(context).colorScheme.primary,
        )),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
