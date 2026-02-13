import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';

import 'widgets/record_player_panel.dart';
import 'widgets/shelf_view_subscribed.dart';
import 'widgets/shelf_view_downloaded.dart';
import 'widgets/shelf_view_history.dart';
import 'widgets/shelf_view_favorites.dart';

import 'widgets/shelf_view_recent_episodes.dart';

/// 唱片架页面
class ShelfScreen extends ConsumerStatefulWidget {
  const ShelfScreen({super.key});

  @override
  ConsumerState<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends ConsumerState<ShelfScreen>
    with AutomaticKeepAliveClientMixin {
  int _selectedTab = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 预加载数据，保持 provider 监听
    final subsAsync = ref.watch(subscriptionsProvider);

    return Scaffold(
      key: const PageStorageKey('shelf_screen'),
      body: RefreshIndicator(
        onRefresh: () async {
          switch (_selectedTab) {
            case 0:
              // 强制刷新本地订阅缓存
              final podcastService = ref.read(podcastServiceProvider);
              final storage = ref.read(storageServiceProvider);
              final subs = await storage.getSubscriptions();
              await podcastService.fetchRecentEpisodesFromLocal(subs,
                  forceRefresh: true);

              ref.invalidate(unifiedRecentEpisodesProvider);
              ref.invalidate(freshrssEpisodesProvider);
              await ref.read(unifiedRecentEpisodesProvider.future);
              break;
            case 1:
              ref.invalidate(subscriptionsProvider);
              ref.invalidate(freshrssSubscriptionsProvider);
              await ref.read(subscriptionsProvider.future);
              break;
            case 2:
              ref.invalidate(downloadedEpisodesProvider);
              await ref.read(downloadedEpisodesProvider.future);
              break;
            case 3:
              ref.read(playHistoryNotifierProvider.notifier).refresh();
              break;
            case 4:
              ref.read(favoritesNotifierProvider.notifier).refresh();
              break;
          }
        },
        child: CustomScrollView(
          slivers: [
            // 标题区域
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '唱片架',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Listening is a way of seeing.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    _buildDateWidget(),
                  ],
                ),
              ),
            ),

            // 播放面板
            const SliverToBoxAdapter(
              child: RecordPlayerPanel(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            // 胶囊按钮
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTabButton('动态', 0, Icons.auto_awesome),
                    const SizedBox(width: 8),
                    _buildTabButton('订阅', 1, Icons.library_music),
                    const SizedBox(width: 8),
                    _buildTabButton('下载', 2, Icons.download),
                    const SizedBox(width: 8),
                    _buildTabButton('历史', 3, Icons.history),
                    const SizedBox(width: 8),
                    _buildTabButton('收藏', 4, Icons.favorite),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 根据选中标签显示不同内容
            _buildContentByTab(subsAsync),

            const SliverToBoxAdapter(child: SizedBox(height: 168)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isSelected = _selectedTab == index;

    // 为每个标签分配不同的传统色
    final Color selectedColor;
    switch (index) {
      case 0:
        selectedColor = const Color(0xFF8A6BBE); // 紫藤
        break;
      case 1:
        selectedColor = const Color(0xFFE35D6A); // 朱红
        break;
      case 2:
        selectedColor = const Color(0xFFF5A6B5); // 桃红
        break;
      case 3:
        selectedColor = const Color(0xFF6B8E77); // 竹绿
        break;
      case 4:
        selectedColor = const Color(0xFFA8BFA3); // 茶绿
        break;
      default:
        selectedColor = const Color(0xFF2C4A6E); // 靛青
    }

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color:
              isSelected ? selectedColor : Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 根据选中的标签构建不同的内容
  Widget _buildContentByTab(AsyncValue subsAsync) {
    switch (_selectedTab) {
      case 0: // 动态
        return const ShelfViewRecentEpisodes();

      case 1: // 订阅
        // 为了类型安全，这里做强制转换或者重新传递
        // 因为 AsyncValue<List<Podcast>> 和 dynamic 的问题
        // 最好的方式是传递给子组件处理
        return ShelfViewSubscribed(subscriptionsAsync: subsAsync as dynamic);

      case 2: // 下载
        return const ShelfViewDownloaded();

      case 3: // 历史
        return const ShelfViewHistory();

      case 4: // 收藏
        return const ShelfViewFavorites();

      default:
        return const SliverFillRemaining(child: SizedBox.shrink());
    }
  }

  Widget _buildDateWidget() {
    final now = DateTime.now();
    const months = [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月',
    ];
    final month = months[now.month - 1];
    final day = now.day.toString();

    return Container(
      width: 42,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.red[400],
              height: 1.2,
            ),
          ),
          Text(
            day,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1F),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
