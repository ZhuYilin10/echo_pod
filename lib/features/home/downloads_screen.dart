import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../player/player_screen.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadedEpisodesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('下载内容'),
        centerTitle: true,
      ),
      body: downloadsAsync.when(
        data: (episodes) {
          if (episodes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_for_offline_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('暂无下载剧集', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                title: Text(episode.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  '${episode.podcastTitle}${episode.pubDate != null ? " · ${episode.pubDate!.year}-${episode.pubDate!.month}-${episode.pubDate!.day}" : ""}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: () async {
                    final confirmed = await _showDeleteConfirm(context);
                    if (confirmed == true) {
                      final downloadService = ref.read(downloadServiceProvider);
                      final storageService = ref.read(storageServiceProvider);
                      await downloadService.deleteDownload(episode.audioUrl!);
                      await storageService.removeDownload(episode.guid);
                      ref.invalidate(downloadedEpisodesProvider);
                    }
                  },
                ),
                onTap: () {
                  ref.read(audioHandlerProvider).playEpisode(episode);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerScreen(episode: episode)),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除下载'),
        content: const Text('确定要删除这集下载的音频吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
