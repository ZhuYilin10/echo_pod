import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../search/search_screen.dart';

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recsAsync = ref.watch(recommendationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('发现宝藏'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildCategoryList(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Text(
                '热门排行榜',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          recsAsync.when(
            data: (recs) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final podcast = recs[index];
                  return ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                    ),
                    title: Text(podcast.title),
                    subtitle: Text(podcast.artist ?? ''),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(podcast.imageUrl ?? '', width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PodcastDetailScreen(podcast: podcast)),
                    ),
                  );
                },
                childCount: recs.length,
              ),
            ),
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverFillRemaining(child: Center(child: Text('加载失败: $e'))),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    final categories = [
      {'name': '商业', 'icon': Icons.trending_up, 'id': '1321'},
      {'name': '科技', 'icon': Icons.biotech, 'id': '1312'},
      {'name': '人文', 'icon': Icons.history_edu, 'id': '1324'},
      {'name': '社会', 'icon': Icons.people_outline, 'id': '1311'},
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      initialQuery: cat['name'] as String,
                      genreId: cat['id'] as String,
                    ),
                  ),
                );
              },
              icon: Icon(cat['icon'] as IconData, size: 18),
              label: Text(cat['name'] as String),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          );
        },
      ),
    );
  }
}
