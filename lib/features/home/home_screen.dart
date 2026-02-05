import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audio_service/audio_service.dart';
import '../../core/providers/providers.dart';
import '../../core/models/episode.dart';
import '../../core/models/podcast.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../search/search_screen.dart';
import '../episode_detail/episode_detail_screen.dart';
import 'downloads_screen.dart';
import '../common/download_button.dart';
import 'package:m3e_collection/m3e_collection.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _exportOpml(BuildContext context, WidgetRef ref) async {
    final storage = ref.read(storageServiceProvider);
    final opmlContent = await storage.exportToOpml();

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/echopod_subs.opml');
    await file.writeAsString(opmlContent);

    await Share.shareXFiles([XFile(file.path)], text: '我的 EchoPod 订阅列表 (OPML)');
  }

  void _showAddRssDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('手动订阅 RSS'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入 RSS 订阅地址 (XML/RSS URL)',
            helperText: '例如: https://example.com/feed.xml',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () async {
              final url = controller.text.trim();
              if (url.isEmpty) return;
              Navigator.pop(context);
              _handleManualSubscription(context, ref, url);
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _handleManualSubscription(
      BuildContext context, WidgetRef ref, String url) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('正在解析订阅地址...')));

    String finalUrl = url;
    // Bilibili link detection
    if (url.contains('bilibili.com/')) {
      final regExp = RegExp(r'space\.bilibili\.com/(\d+)');
      final match = regExp.firstMatch(url);
      if (match != null) {
        final uid = match.group(1);
        finalUrl = 'echopod://bilibili/user/$uid';
      }
    }

    final podcastService = ref.read(podcastServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    final podcast = await podcastService.fetchPodcastMetadata(finalUrl);

    if (podcast != null) {
      await storageService.subscribe(podcast);
      ref.invalidate(subscriptionsProvider);
      ref.invalidate(recentSubscribedEpisodesProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('订阅成功: ${podcast.title}')));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('无法解析该地址，请检查格式是否正确')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsAsync = ref.watch(subscriptionsProvider);
    final recentAsync = ref.watch(recentSubscribedEpisodesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EchoPod'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.download_for_offline_rounded),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DownloadsScreen())),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen())),
          ),
          IconButton(
              icon: const Icon(Icons.add_link_rounded),
              onPressed: () => _showAddRssDialog(context, ref)),
          IconButton(
              icon: const Icon(Icons.output_rounded),
              onPressed: () => _exportOpml(context, ref)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(subscriptionsProvider);
          ref.invalidate(recentSubscribedEpisodesProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Subscribed Podcasts Horizontal List (Small area)
            SliverToBoxAdapter(
              child: _buildSubscribedChannels(context, subsAsync),
            ),

            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text('最新单集',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // Recent Episodes Vertical List (Main area)
            recentAsync.when(
              data: (episodes) => episodes.isEmpty
                  ? _buildEmptyStateSliver(context)
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildEpisodeItem(context, ref, episodes[index]),
                        childCount: episodes.length,
                      ),
                    ),
              loading: () => SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicatorM3E(
                size: CircularProgressM3ESize.m,
                activeColor: Theme.of(context).colorScheme.primary,
              ))),
              error: (e, s) =>
                  SliverFillRemaining(child: Center(child: Text('加载失败: $e'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribedChannels(
      BuildContext context, AsyncValue<List<Podcast>> subsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('我的订阅',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        SizedBox(
          height: 100,
          child: subsAsync.when(
            data: (subs) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: subs.length,
              itemBuilder: (context, index) {
                final podcast = subs[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PodcastDetailScreen(podcast: podcast))),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(podcast.imageUrl ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.podcasts)),
                        ),
                        const SizedBox(height: 4),
                        Text(podcast.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodeItem(
      BuildContext context, WidgetRef ref, Episode episode) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Hero(
        tag: 'episode_artwork_${episode.guid}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            episode.imageUrl ?? '',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              color: Colors.grey[800],
              child: const Icon(Icons.music_note_rounded,
                  size: 24, color: Colors.white24),
            ),
          ),
        ),
      ),
      title: Text(episode.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(
          '${episode.podcastTitle} · ${episode.pubDate?.month}月${episode.pubDate?.day}日',
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final isCurrent = snapshot.data?.id == episode.guid;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add to Queue
              IconButton(
                icon: const Icon(Icons.playlist_add_rounded, size: 24),
                onPressed: () {
                  audioHandler.addQueueItem(MediaItem(
                    id: episode.guid,
                    album: episode.podcastTitle,
                    title: episode.title,
                    artUri: episode.imageUrl != null
                        ? Uri.parse(episode.imageUrl!)
                        : null,
                    extras: episode.toJson(),
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('已加入播放列表'),
                        duration: Duration(seconds: 1)),
                  );
                },
              ),
              StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, pbSnapshot) {
                  final playing = pbSnapshot.data?.playing ?? false;
                  return IconButton(
                    icon: Icon(
                      (isCurrent && playing)
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      size: 28,
                      color: Colors.indigoAccent,
                    ),
                    onPressed: () {
                      if (isCurrent) {
                        playing ? audioHandler.pause() : audioHandler.play();
                      } else {
                        audioHandler.playEpisode(episode);
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EpisodeDetailScreen(episode: episode)),
        );
      },
    );
  }

  Widget _buildEmptyStateSliver(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.podcasts_rounded, size: 64, color: Colors.white24),
            SizedBox(height: 16),
            Text('暂无更新', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
