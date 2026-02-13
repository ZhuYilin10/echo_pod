import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/providers.dart';
import '../services/web_podcast_service.dart';
import 'shelf/shelf_screen.dart';
import 'shelf/widgets/collapsible_player_header.dart';
import 'world/world_screen.dart';

class MainNavigationWrapper extends ConsumerStatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  ConsumerState<MainNavigationWrapper> createState() =>
      _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends ConsumerState<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ShelfScreen(),
    const WorldScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Link AudioHandler with VideoPodcastController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioHandler = ref.read(audioHandlerProvider);
      final webController = ref.read(videoPodcastControllerProvider.notifier);
      audioHandler.setWebAudioController(webController);

      // Start listening to current episode to refresh history
      final audioHandler2 = ref.read(audioHandlerProvider);
      audioHandler2.currentEpisodeStream.listen((episode) {
        if (episode != null) {
          ref.read(playHistoryNotifierProvider.notifier).refresh();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 主内容
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // 浮动 Mini Player — 定位在 tabbar 正上方
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 56,
            child: const FloatingMiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: CNTabBar(
        iconSize: 20,
        items: const [
          CNTabBarItem(
            label: '唱片架',
            icon: CNSymbol('rectangle.on.rectangle'),
            activeIcon: CNSymbol('rectangle.fill.on.rectangle.fill'),
          ),
          CNTabBarItem(
            label: '世界',
            icon: CNSymbol('globe'),
            activeIcon: CNSymbol('globe'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
