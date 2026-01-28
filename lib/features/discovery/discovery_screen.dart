import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../search/search_screen.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  String _selectedGenreId = 'all';
  String _selectedGenreName = '热门排行榜';

  final List<Map<String, dynamic>> _categories = [
    {'name': '全部', 'icon': Icons.stars_rounded, 'id': 'all'},
    {'name': '商业', 'icon': Icons.trending_up, 'id': '1321'},
    {'name': '科技', 'icon': Icons.biotech, 'id': '1312'},
    {'name': '人文', 'icon': Icons.history_edu, 'id': '1324'},
    {'name': '社会', 'icon': Icons.people_outline, 'id': '1311'},
    {'name': '艺术', 'icon': Icons.palette_outlined, 'id': '1301'},
    {'name': '生活', 'icon': Icons.coffee_outlined, 'id': '1302'},
  ];

  @override
  Widget build(BuildContext context) {
    final podcastsAsync = ref.watch(genrePodcastsProvider(_selectedGenreId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('发现宝藏'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              _selectedGenreName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: podcastsAsync.when(
              data: (podcasts) => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.deepPurpleAccent.withOpacity(0.7)
                      ),
                    ),
                    title: Text(podcast.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(podcast.artist ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        podcast.imageUrl ?? '', 
                        width: 45, height: 45, 
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PodcastDetailScreen(podcast: podcast)),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('加载失败: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedGenreId == cat['id'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat['name']),
              avatar: Icon(cat['icon'], size: 16, color: isSelected ? Colors.white : Colors.deepPurpleAccent),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGenreId = cat['id'];
                  _selectedGenreName = isSelected ? _selectedGenreName : '${cat['name']}频道';
                });
              },
              selectedColor: Colors.deepPurpleAccent,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
            ),
          );
        },
      ),
    );
  }
}
