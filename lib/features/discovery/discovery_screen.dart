import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:animations/animations.dart';
import '../../core/models/podcast.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../podcast_detail/podcast_detail_screen.dart';
import '../search/search_screen.dart';
import '../episode_detail/episode_detail_screen.dart';
import 'package:m3e_collection/m3e_collection.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  String _selectedGenreId = 'all';
  String _selectedGenreName = '热门推荐';

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
  int _displayCount = 20;
  bool _isLoadingMore = false;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
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

  void _showWebAudioDialog(BuildContext context) {
    // Keep existing implementation
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('万物皆可播 (实验室)',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('支持粘贴 Bilibili/YouTube 等网页链接，直接作为音频收听',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '粘贴视频网页链接...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isEmpty) return;
              Navigator.pop(context);
              _handleWebUrl(url);
            },
            child: const Text('开始收听'),
          ),
        ],
      ),
    );
  }

  void _handleWebUrl(String input) async {
    // Keep existing implementation details
    // Smart Link Extraction
    final urlRegExp = RegExp(
        r'((https?:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?)',
        caseSensitive: false);
    final match = urlRegExp.firstMatch(input);

    if (match == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('未发现有效链接')),
      );
      return;
    }

    final url = match.group(0)!;

    // Special handling for Xiaoyuzhou
    if (url.contains('xiaoyuzhoufm.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在解析小宇宙音频...')),
      );
      final episode =
          await ref.read(xiaoyuzhouParserServiceProvider).parseUrl(url);
      if (episode != null) {
        ref.read(audioHandlerProvider).playEpisode(episode);
        return;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('解析小宇宙音频失败，请尝试其他链接')),
          );
        }
      }
      return;
    }

    // Extract potential title from bracketed text 【...】
    String title = '网页音频解析中...';
    final titleRegExp = RegExp(r'【([^】]+)】');
    final titleMatch = titleRegExp.firstMatch(input);
    if (titleMatch != null) {
      title = titleMatch.group(1)!;
    }

    // For now, create a mock episode and play via our web infrastructure
    final episode = Episode(
      guid: 'web_${url.hashCode}',
      title: title,
      podcastTitle: '万物皆可播',
      audioUrl: url,
      podcastFeedUrl: 'web_pseudo_feed',
      imageUrl:
          'https://images.unsplash.com/photo-1478737270239-2f02b77ac6d5?q=80&w=1000&auto=format&fit=crop',
    );

    ref.read(audioHandlerProvider).playEpisode(episode);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正在通过隐形助手加载网页音频...')),
    );
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

  @override
  Widget build(BuildContext context) {
    final AsyncValue<dynamic> dataAsync =
        _selectedGenreId == 'trending_episodes'
            ? ref.watch(trendingEpisodesProvider)
            : ref.watch(genrePodcastsProvider(_selectedGenreId));

    debugPrint(
        'DiscoveryScreen: Building. Genre: $_selectedGenreId, AsyncState: $dataAsync');

    if (dataAsync.hasValue) {
      final data = dataAsync.value;
      if (data is List) {
        debugPrint('DiscoveryScreen: Received list with ${data.length} items');
      } else {
        debugPrint(
            'DiscoveryScreen: Received data of type ${data.runtimeType}');
      }
    }
    if (dataAsync.hasError) {
      debugPrint('DiscoveryScreen: Error state: ${dataAsync.error}');
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        notificationPredicate: (notification) {
          // Allow refresh even if not full screen
          return notification.depth == 0;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              title: Text(
                'Discover',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.auto_awesome_rounded),
                  onPressed: () => _showWebAudioDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen())),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: _buildCategoryBar(),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  _selectedGenreName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            dataAsync.when(
              data: (data) {
                final list = data is List ? data : [];
                if (list.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 48, color: colorScheme.outline),
                          const SizedBox(height: 16),
                          Text('暂无数据',
                              style: TextStyle(color: colorScheme.outline)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _onRefresh,
                            child: const Text('刷新试试'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final count = _displayCount.clamp(0, list.length);
                final displayedData = list.sublist(0, count);

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
                          padding: EdgeInsets.all(8.0),
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
              loading: () => SliverFillRemaining(
                child: Center(
                    child: CircularProgressIndicatorM3E(
                  size: CircularProgressM3ESize.m,
                  activeColor: Theme.of(context).colorScheme.primary,
                )),
              ),
              error: (e, s) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            size: 48, color: colorScheme.error),
                        const SizedBox(height: 16),
                        Text(
                          '加载失败',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          e.toString().replaceAll('Exception: ', ''),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _onRefresh,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
                child: SizedBox(height: 80)), // Bottom padding
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Haptic feedback
    // HapticFeedback.mediumImpact(); // Optional

    if (_selectedGenreId == 'trending_episodes') {
      return ref.refresh(trendingEpisodesProvider.future).ignore();
    } else {
      return ref
          .refresh(genrePodcastsProvider(_selectedGenreId).future)
          .ignore();
    }
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

          return FilterChip(
            label: Text(cat['name']),
            avatar: isSelected ? null : Icon(cat['icon'], size: 16),
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
            selectedColor: colorScheme.secondaryContainer,
            labelStyle: TextStyle(
              color: isSelected
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            onSelected: (selected) {
              if (_selectedGenreId == cat['id']) return;
              setState(() {
                _selectedGenreId = cat['id'];
                _selectedGenreName =
                    cat['name'] == '全部' ? '热门推荐' : '${cat['name']}频道';
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
                    image: DecorationImage(
                      image: NetworkImage(podcast.imageUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
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
    final audioHandler = ref.watch(audioHandlerProvider);
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
            // Use AspectRatio to constrain height in MasonryGrid
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
                                image: NetworkImage(episode.imageUrl!),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {},
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
                                onPressed: () async {
                                  // Play logic...
                                  var epToPlay = episode;
                                  if (epToPlay.audioUrl == null) {
                                    // ... existing play logic ...
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('正在解析音频地址...'),
                                          duration: Duration(seconds: 1)),
                                    );
                                    final resolved = await ref
                                        .read(podcastServiceProvider)
                                        .resolveEpisodeUrl(episode);
                                    if (resolved != null) {
                                      epToPlay = resolved;
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('无法解析音频地址')));
                                      }
                                      return;
                                    }
                                  }
                                  audioHandler.playEpisode(epToPlay);
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
}
