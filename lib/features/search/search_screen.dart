import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/podcast.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../podcast_detail/podcast_detail_screen.dart';

import '../../services/semantic_search_service.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final String? genreId;

  const SearchScreen({super.key, this.initialQuery, this.genreId});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  List<Podcast> _podcastResults = [];
  List<SearchResult> _contentResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }

    // Auto search if initial parameters are provided
    if (widget.initialQuery != null || widget.genreId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _search());
    }
  }

  void _search() async {
    if (_searchController.text.isEmpty) return;
    setState(() => _isLoading = true);

    if (_tabController.index == 0) {
      final service = ref.read(podcastServiceProvider);
      // Use 'podcast' as term if only genre is provided
      final term =
          _searchController.text.isEmpty ? 'podcast' : _searchController.text;
      _podcastResults =
          await service.searchPodcasts(term, genre: widget.genreId);
    } else {
      final semanticService = ref.read(semanticSearchServiceProvider);
      _contentResults =
          await semanticService.searchContent(_searchController.text);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索播客或内容...',
            border: InputBorder.none,
          ),
          onSubmitted: (_) => _search(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurpleAccent,
          tabs: const [
            Tab(text: '搜频道'),
            Tab(text: '搜内容 (AI)'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _search),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPodcastList(),
          _buildContentList(),
        ],
      ),
    );
  }

  Widget _buildPodcastList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_podcastResults.isEmpty) {
      return const Center(child: Text('输入关键词搜索中文播客'));
    }

    return ListView.builder(
      itemCount: _podcastResults.length,
      itemBuilder: (context, index) {
        final podcast = _podcastResults[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              podcast.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
            ),
          ),
          title: Text(podcast.title, maxLines: 1),
          subtitle: Text(podcast.artist ?? '', maxLines: 1),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PodcastDetailScreen(podcast: podcast)),
          ),
        );
      },
    );
  }

  Widget _buildContentList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_contentResults.isEmpty) {
      return const Center(child: Text('AI 正在为您检索全网播客内容...\n试试搜“Flutter 渲染”'));
    }

    return ListView.builder(
      itemCount: _contentResults.length,
      itemBuilder: (context, index) {
        final result = _contentResults[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[900],
          child: ListTile(
            title: Text(result.episodeTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${result.podcastTitle} · 时间点 ${result.timestamp}',
                    style: const TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 12)),
                const SizedBox(height: 8),
                Text(result.snippet,
                    style: const TextStyle(
                        fontSize: 13, fontStyle: FontStyle.italic)),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              // Creating a mock episode from search results for immediate playback
              final episode = Episode(
                guid: 'search_${result.episodeTitle}_${result.timestamp}',
                title: result.episodeTitle,
                podcastTitle: result.podcastTitle,
                description: result.snippet,
                // audioUrl: needs actual url, for now mock or add to SearchResult
              );
              ref
                  .read(audioHandlerProvider)
                  .playEpisode(episode, autoPlay: false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已加载: ${episode.title}'),
                  action: SnackBarAction(
                    label: '播放',
                    onPressed: () => ref.read(audioHandlerProvider).play(),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
