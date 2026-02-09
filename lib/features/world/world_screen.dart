import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:animations/animations.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/models/podcast.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../episode_detail/episode_detail_screen.dart';
import '../search/search_screen.dart';

class WorldScreen extends ConsumerStatefulWidget {
  const WorldScreen({super.key});

  @override
  ConsumerState<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends ConsumerState<WorldScreen> {
  // Indices to select: randomly 5 from top 30
  late final List<int> _selectedIndices;

  // Category State
  String _selectedGenreId = 'all';
  String _selectedGenreName = '热门推荐';

  final List<Map<String, dynamic>> _categories = [
    {'name': '热门节目', 'icon': Icons.stars_rounded, 'id': 'all'},
    {'name': '热门单集', 'icon': Icons.whatshot_rounded, 'id': 'trending_episodes'},
    {'name': '商业', 'icon': Icons.trending_up, 'id': '1321'},
    {'name': '科技', 'icon': Icons.biotech, 'id': '1318'},
    {'name': '人文', 'icon': Icons.history_edu, 'id': '1324'},
    {'name': '社会', 'icon': Icons.people_outline, 'id': '1311'},
    {'name': '艺术', 'icon': Icons.palette_outlined, 'id': '1301'},
    {'name': '生活', 'icon': Icons.coffee_outlined, 'id': '1302'},
  ];

  // Pagination & Scroll State
  final ScrollController _scrollController = ScrollController();
  int _displayCount = 20;
  bool _isLoadingMore = false;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    // Randomly select 5 unique indices from 0 to 29
    _selectedIndices =
        (List<int>.generate(30, (i) => i)..shuffle()).take(5).toList()..sort();
    _scrollController.addListener(_onScroll);
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
    if (_isLoadingMore) return;

    final provider = _selectedGenreId == 'trending_episodes'
        ? trendingEpisodesProvider
        : genrePodcastsProvider(_selectedGenreId);

    final asyncValue = ref.read(provider);

    if (!asyncValue.hasValue) return;

    final fullList = asyncValue.value as List;
    if (_displayCount >= fullList.length) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _displayCount += _pageSize;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    // Refresh trending episodes for carousel
    ref.invalidate(trendingEpisodesProvider);

    // Refresh content provider
    if (_selectedGenreId == 'trending_episodes') {
      await ref.refresh(trendingEpisodesProvider.future);
    } else {
      await ref.refresh(genrePodcastsProvider(_selectedGenreId).future);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the providers
    final trendingAsync = ref.watch(trendingEpisodesProvider);
    final contentAsync = _selectedGenreId == 'trending_episodes'
        ? ref.watch(trendingEpisodesProvider)
        : ref.watch(genrePodcastsProvider(_selectedGenreId));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
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
                          '世界',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Discover the world.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.search_rounded),
                      iconSize: 28,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Carousel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: trendingAsync.when(
                  data: (episodes) {
                    if (episodes.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // Select specific episodes
                    final List<Episode> selectedEpisodes = [];
                    for (final index in _selectedIndices) {
                      if (index < episodes.length) {
                        selectedEpisodes.add(episodes[index]);
                      }
                    }

                    if (selectedEpisodes.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: SizedBox(
                        height: 200,
                        child: CarouselView(
                          itemExtent: 300,
                          shrinkExtent: 100,
                          children:
                              selectedEpisodes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final episode = entry.value;
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EpisodeDetailScreen(episode: episode),
                                  ));
                                },
                                child: _buildCarouselItem(
                                    context, episode, index));
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicatorM3E(
                        size: CircularProgressM3ESize.m,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Category Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 8),
                child: _buildCategoryBar(),
              ),
            ),

            // Category Label
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  _selectedGenreName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Main Content Grid
            contentAsync.when(
              data: (data) {
                final displayedData = data.sublist(
                  0,
                  _displayCount.clamp(0, data.length),
                );

                if (displayedData.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: Text('暂无数据')),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: displayedData.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == displayedData.length) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicatorM3E(
                            size: CircularProgressM3ESize.s,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ));
                      }
                      final item = displayedData[index];
                      if (item is Podcast) {
                        return _buildExpressivePodcastCard(item, index);
                      } else if (item is Episode) {
                        return _buildExpressiveEpisodeCard(item, index);
                      }
                      return const SizedBox();
                    },
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicatorM3E(
                      size: CircularProgressM3ESize.m,
                    ),
                  ),
                ),
              ),
              error: (e, s) => SliverToBoxAdapter(
                child: Center(child: Text('加载失败: $e')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Episode episode, int index) {
    final imageUrl = episode.imageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    final isFirst = index == 0;
    final isLast = index == _selectedIndices.length - 1;

    return Padding(
      padding: EdgeInsets.only(
        left: isFirst ? 16 : 0,
        right: isLast ? 16 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image Layer with High-Res Logic and Fallback
                    if (hasImage)
                      CachedNetworkImage(
                        imageUrl: _getHighResUrl(imageUrl),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          // Fallback to original URL if high-res fails
                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const SizedBox(),
                          );
                        },
                      ),

                    // Border Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: Column(
              children: [
                Text(
                  episode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  episode.podcastTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedGenreId == cat['id'];
          final colorScheme = Theme.of(context).colorScheme;

          // Cycle through theme accent colors
          final List<Color> themeColors = [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
            colorScheme.primary, // Cycle back
            colorScheme.secondary,
            colorScheme.tertiary,
          ];
          final Color catColor = themeColors[index % themeColors.length];

          return FilterChip(
            label: Text(cat['name']),
            avatar: Icon(
              cat['icon'],
              size: 16,
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            selected: isSelected,
            showCheckmark: false,
            // Expressive chip styling
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isSelected
                  ? BorderSide.none
                  : BorderSide(color: colorScheme.outlineVariant),
            ),
            backgroundColor: Colors.transparent,
            selectedColor:
                catColor.withOpacity(0.2), // Light background for selection
            labelStyle: TextStyle(
              color: isSelected
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            onSelected: (selected) {
              if (_selectedGenreId == cat['id']) return;
              setState(() {
                _selectedGenreId = cat['id'];
                _selectedGenreName =
                    cat['name'] == '热门节目' ? '热门推荐' : '${cat['name']}频道';
                _displayCount = _pageSize;
                _isLoadingMore = false;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildExpressivePodcastCard(Podcast podcast, int index) {
    // Staggered height logic based on index for visual rhythm
    final isTall = index % 3 == 0;

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) => PodcastDetailScreen(podcast: podcast),
      closedElevation: 0,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      closedColor: Colors.transparent,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: isTall ? 0.8 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: podcast.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(podcast.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                podcast.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                podcast.artist ?? 'Unknown',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpressiveEpisodeCard(Episode episode, int index) {
    final isTall = index % 4 == 0 || index % 4 == 3;

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) => EpisodeDetailScreen(episode: episode),
      closedElevation: 0,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      closedColor: Colors.transparent,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: AspectRatio(
              aspectRatio: isTall ? 0.7 : 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: isTall ? 5 : 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        image: (episode.imageUrl != null &&
                                episode.imageUrl!.isNotEmpty)
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    _getHighResUrl(episode.imageUrl!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.play_arrow_rounded),
                                constraints: const BoxConstraints.tightFor(
                                    width: 36, height: 36),
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                onPressed: () {
                                  ref
                                      .read(audioHandlerProvider)
                                      .playEpisode(episode);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          const Spacer(),
                          Text(
                            episode.podcastTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getHighResUrl(String url) {
    if (url.contains('100x100bb.jpg')) {
      return url.replaceFirst('100x100bb.jpg', '500x500bb.jpg');
    }
    return url;
  }

  // Helper for decoration since Container handles it but we want standalone gradient sometimes
  Widget decoratedBox({required BoxDecoration decoration}) {
    return Container(decoration: decoration);
  }
}
