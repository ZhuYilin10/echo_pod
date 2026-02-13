import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_config.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/image_utils.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../episode_detail/episode_detail_screen.dart';
import '../../core/models/podcast.dart';
import '../../core/models/episode.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isComposing = false;
  bool _initialized = false;
  bool _hotSearchExpanded = false;
  Timer? _debounceTimer;
  List<Episode> _randomRecommendations = [];
  List<String> _hotSearchLabels = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onControllerChange);
  }

  void _initializeIfNeeded() {
    if (_initialized) return;
    _initialized = true;
    ref.read(searchQueryProvider.notifier).state = '';
    _searchController.clear();
    _isSearching = false;
    _randomRecommendations = [];
    _hotSearchLabels = [];
  }

  void _onControllerChange() {
    final composing = _searchController.value.composing;
    if (composing.isValid && composing.start < composing.end) {
      _isComposing = true;
    } else if (_isComposing) {
      _isComposing = false;
      _onSearchChanged(_searchController.text);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onControllerChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializeIfNeeded();

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.ricePaper,
      body: _isSearching || searchQuery.isNotEmpty
          ? _buildSearchResults(searchResults)
          : _buildExploreContent(bottomPadding),
    );
  }

  Widget _buildExploreContent(double bottomPadding) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildHotSearchSection(),
          const SizedBox(height: 28),
          _buildRecommendationSection(),
          SizedBox(height: bottomPadding + 100),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<Podcast>> searchResults) {
    return Column(
      children: [
        _buildHeader(),
        _buildSearchBar(),
        const SizedBox(height: 16),
        Expanded(
          child: searchResults.when(
            data: (podcasts) {
              if (podcasts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.softBeige.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 36,
                          color: AppColors.vermillion,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '未找到相关播客',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '换个关键词试试？',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  final podcast = podcasts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSearchResultCard(podcast),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.vermillion),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '搜索出错: $error',
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(Podcast podcast) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PodcastDetailScreen(podcast: podcast),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                ImageUtils.getHighResUrl(podcast.imageUrl),
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 90,
                  color: AppColors.softBeige,
                  child: const Icon(
                    Icons.podcasts,
                    color: AppColors.vermillion,
                    size: 36,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podcast.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            podcast.artist ?? '未知主播',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.vermillion.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.vermillion,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 16,
        16,
        16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '探索',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Passion guides discovery.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            iconSize: 28,
            splashColor: AppColors.vermillion.withValues(alpha: 0.2),
            highlightColor: AppColors.vermillion.withValues(alpha: 0.1),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.softBeige,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '搜索节目、主播或话题',
                  hintStyle: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                ),
                onChanged: _onSearchChanged,
                onSubmitted: (value) {
                  _performSearch(value);
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _performSearch(_searchController.text);
              },
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: AppColors.vermillion,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
      });
      ref.read(searchQueryProvider.notifier).state = '';
      return;
    }
    setState(() {
      _isSearching = true;
    });
    ref.read(searchQueryProvider.notifier).state = query.trim();
  }

  void _onSearchChanged(String value) {
    if (_isComposing) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(value);
    });
  }

  Widget _buildHotSearchSection() {
    final trendingAsync = ref.watch(trendingEpisodesProvider);

    return trendingAsync.when(
      data: (episodes) {
        if (episodes.isEmpty) {
          return const SizedBox.shrink();
        }

        // Extract keywords and cache
        if (_hotSearchLabels.isEmpty) {
          final keywords = <String>{};
          for (final ep in episodes) {
            final parts = ep.title.split(RegExp(r'[-–:：vol\.·]'));
            for (final part in parts) {
              final trimmed = part.trim();
              if (trimmed.isNotEmpty &&
                  trimmed.length >= 2 &&
                  trimmed.length <= 10) {
                keywords.add(trimmed);
              }
            }
            if (ep.podcastTitle.isNotEmpty) {
              keywords.add(ep.podcastTitle);
            }
          }
          _hotSearchLabels = keywords.toList()..shuffle();
        }

        final displayLabels = _hotSearchExpanded
            ? _hotSearchLabels.take(15).toList()
            : _hotSearchLabels.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '热门搜索',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _hotSearchExpanded = !_hotSearchExpanded;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _hotSearchExpanded ? '收起' : '更多',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.vermillion,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: displayLabels.map((label) {
                        return _buildHotSearchTag(label: label);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildHotSearchTag({required String label}) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFF9B59B6),
      const Color(0xFF3498DB),
      const Color(0xFFE67E22),
      const Color(0xFF1ABC9C),
    ];
    final color = colors[label.hashCode % colors.length];

    return InkWell(
      onTap: () {
        _searchController.text = label;
        _performSearch(label);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection() {
    final trendingAsync = ref.watch(trendingEpisodesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '猜你喜欢',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: trendingAsync.when(
            data: (episodes) {
              if (episodes.isEmpty) {
                return _buildEmptyRecommendations();
              }
              if (_randomRecommendations.isEmpty) {
                final shuffled = List<Episode>.from(episodes)..shuffle();
                _randomRecommendations = shuffled.take(3).toList();
              }
              return Column(
                children: _randomRecommendations.map((episode) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildRecommendationCard(episode: episode),
                  );
                }).toList(),
              );
            },
            loading: () => _buildLoadingRecommendations(),
            error: (error, stack) => _buildErrorRecommendations(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          '暂无推荐',
          style: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }

  Widget _buildLoadingRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.vermillion),
      ),
    );
  }

  Widget _buildErrorRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          '加载失败',
          style: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({required Episode episode}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EpisodeDetailScreen(episode: episode),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      ImageUtils.getHighResUrl(episode.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.softBeige,
                        child: const Icon(Icons.podcasts,
                            color: AppColors.vermillion),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          episode.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (episode.duration != null)
                        Text(
                          episode.duration!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    episode.podcastTitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
