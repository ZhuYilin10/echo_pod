import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../core/providers/providers.dart';
import 'player_screen.dart';
import 'playlist_screen.dart';
import '../../core/models/episode.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        if (mediaItem == null) return const SizedBox.shrink();

        return Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Progress Bar
              StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final position = state?.updatePosition ?? Duration.zero;
                  final duration = mediaItem.duration ?? Duration.zero;
                  final progress = duration.inMilliseconds > 0
                      ? position.inMilliseconds / duration.inMilliseconds
                      : 0.0;

                  return Positioned.fill(
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                      ),
                    ),
                  );
                },
              ),
              // Main Content
              InkWell(
                onTap: () {
                  final episode = mediaItem.extras != null
                      ? Episode.fromJson(mediaItem.extras!)
                      : Episode(
                          guid: mediaItem.id,
                          title: mediaItem.title,
                          podcastTitle: mediaItem.album ?? '',
                          imageUrl: mediaItem.artUri?.toString(),
                          audioUrl: mediaItem.id,
                        );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerScreen(episode: episode)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'episode_artwork_${mediaItem.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            mediaItem.artUri?.toString() ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mediaItem.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              mediaItem.album ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<PlaybackState>(
                        stream: audioHandler.playbackState,
                        builder: (context, snapshot) {
                          final playing = snapshot.data?.playing ?? false;
                          return IconButton(
                            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                            onPressed: playing ? audioHandler.pause : audioHandler.play,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.playlist_play_rounded),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlaylistScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
