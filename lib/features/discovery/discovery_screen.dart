import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../core/models/podcast.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../search/search_screen.dart';
import '../episode_detail/episode_detail_screen.dart';

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
    {'name': '热门单集', 'icon': Icons.whatshot_rounded, 'id': 'trending_episodes'},
    {'name': '商业', 'icon': Icons.trending_up, 'id': '1321'},
    {'name': '科技', 'icon': Icons.biotech, 'id': '1318'},
    {'name': '人文', 'icon': Icons.history_edu, 'id': '1324'},
    {'name': '社会', 'icon': Icons.people_outline, 'id': '1311'},
    {'name': '艺术', 'icon': Icons.palette_outlined, 'id': '1301'},
    {'name': '生活', 'icon': Icons.coffee_outlined, 'id': '1302'},
  ];

  final ScrollController _scrollController = ScrollController();
  List<dynamic> _allData = []; // Can be List<Podcast> or List<Episode>
  final List<dynamic> _displayedData = [];
  bool _isLoadingMore = false;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() async {
    if (!mounted) return;
    
    if (_selectedGenreId == 'trending_episodes') {
      final episodes = await ref.read(trendingEpisodesProvider.future);
      if (mounted) {
        setState(() {
          _allData = episodes;
          _displayedData.clear();
          final count = _pageSize.clamp(0, _allData.length);
          if (count > 0) {
            _displayedData.addAll(_allData.sublist(0, count));
          }
        });
      }
    } else {
      final podcasts = await ref.read(genrePodcastsProvider(_selectedGenreId).future);
      if (mounted) {
        setState(() {
          _allData = podcasts;
          _displayedData.clear();
          final count = _pageSize.clamp(0, _allData.length);
          if (count > 0) {
            _displayedData.addAll(_allData.sublist(0, count));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _displayedData.length >= _allData.length) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        final startIndex = _displayedData.length;
        final endIndex = (startIndex + _pageSize).clamp(0, _allData.length);
        if (startIndex < endIndex) {
          _displayedData.addAll(_allData.sublist(startIndex, endIndex));
        }
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which async provider to watch
    final AsyncValue<dynamic> dataAsync = _selectedGenreId == 'trending_episodes'
        ? ref.watch(trendingEpisodesProvider)
        : ref.watch(genrePodcastsProvider(_selectedGenreId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('发现宝藏'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen())),
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
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              data: (_) {
                if (_allData.isEmpty && _displayedData.isEmpty) {
                  return const Center(child: Text('暂无数据'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: _displayedData.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _displayedData.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = _displayedData[index];
                    if (item is Podcast) {
                      return _buildPodcastTile(index, item);
                    } else if (item is Episode) {
                      return _buildEpisodeTile(index, item);
                    }
                    return const SizedBox();
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('加载失败: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastTile(int index, Podcast podcast) {
    return ListTile(
      leading: Text(
        '${index + 1}',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent.withOpacity(0.7)),
      ),
      title: Text(podcast.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(podcast.artist ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          podcast.imageUrl ?? '',
          width: 45,
          height: 45,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PodcastDetailScreen(podcast: podcast)),
      ),
    );
  }

  Widget _buildEpisodeTile(int index, Episode episode) {
    final audioHandler = ref.watch(audioHandlerProvider);
    return ListTile(
      leading: Text(
        '${index + 1}',
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent),
      ),
      title: Text(episode.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(episode.podcastTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final isCurrent = snapshot.data?.id == episode.guid;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.playlist_add_rounded, size: 24),
                onPressed: () {
                  audioHandler.addQueueItem(MediaItem(
                    id: episode.guid,
                    album: episode.podcastTitle,
                    title: episode.title,
                    artUri: episode.imageUrl != null ? Uri.parse(episode.imageUrl!) : null,
                    extras: episode.toJson(),
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已加入播放列表'), duration: Duration(seconds: 1)));
                },
              ),
              StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, pbSnapshot) {
                  final playing = pbSnapshot.data?.playing ?? false;
                  return IconButton(
                    icon: Icon(
                      (isCurrent && playing) ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                      size: 28,
                      color: Colors.tealAccent,
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EpisodeDetailScreen(episode: episode)),
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
              avatar: Icon(cat['icon'],
                  size: 16,
                  color: isSelected ? Colors.white : Colors.deepPurpleAccent),
              selected: isSelected,
              onSelected: (selected) {
                if (_selectedGenreId == cat['id']) return;
                setState(() {
                  _selectedGenreId = cat['id'];
                  _selectedGenreName = '${cat['name']}频道';
                  _allData.clear();
                  _displayedData.clear();
                  _isLoadingMore = false;
                });
                _fetchInitialData();
              },
              selectedColor: Colors.deepPurpleAccent,
              checkmarkColor: Colors.white,
              labelStyle:
                  TextStyle(color: isSelected ? Colors.white : Colors.white70),
            ),
          );
        },
      ),
    );
  }
}
