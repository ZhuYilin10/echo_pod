import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../core/providers/providers.dart';

class PlaylistScreen extends ConsumerWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('播放列表'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<MediaItem>>(
        stream: audioHandler.queue,
        builder: (context, snapshot) {
          final queue = snapshot.data ?? [];
          if (queue.isEmpty) {
            return Center(
                child: Text('播放列表空空如也',
                    style: Theme.of(context).textTheme.bodyMedium));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final item = queue[index];
              final isCurrent = audioHandler.mediaItem.value?.id == item.id;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(item.artUri.toString(),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.podcasts)),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(item.album ?? '',
                    style: const TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => audioHandler.removeQueueItemAt(index),
                ),
                onTap: () => audioHandler.skipToQueueItem(index),
              );
            },
          );
        },
      ),
    );
  }
}
