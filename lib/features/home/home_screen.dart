import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../search/search_screen.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import 'downloads_screen.dart';

import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
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

  void _handleManualSubscription(BuildContext context, WidgetRef ref, String url) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('正在解析 RSS 地址...')));
    
    final podcastService = ref.read(podcastServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    
    final podcast = await podcastService.fetchPodcastMetadata(url);
    
    if (podcast != null) {
      await storageService.subscribe(podcast);
      ref.invalidate(subscriptionsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('订阅成功: ${podcast.title}')));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('无法解析该地址，请检查格式是否正确')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsAsync = ref.watch(subscriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的订阅'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.download_for_offline_rounded),
          tooltip: '查看下载',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DownloadsScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_link_rounded),
            tooltip: '手动添加 RSS',
            onPressed: () => _showAddRssDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.output_rounded),
            tooltip: '导出 OPML',
            onPressed: () => _exportOpml(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(subscriptionsProvider);
          // Wait for the future to complete
          await ref.read(subscriptionsProvider.future);
        },
        child: subsAsync.when(
          data: (subs) => subs.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildEmptyState(context),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: subs.length,
                  itemBuilder: (context, index) => _buildPodcastCard(context, subs[index]),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildPodcastCard(BuildContext context, podcast) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PodcastDetailScreen(podcast: podcast)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                podcast.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.podcasts, size: 50),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            podcast.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            podcast.artist ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.podcasts_rounded, size: 100, color: Colors.deepPurple.withOpacity(0.3)),
          const SizedBox(height: 24),
          const Text('发现你喜欢的声音', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('订阅播客后，它们将出现在这里', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            ),
            icon: const Icon(Icons.search),
            label: const Text('开始探索'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
