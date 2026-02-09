import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/providers.dart';
import '../services/web_podcast_service.dart';
import 'discovery/discovery_screen.dart';
import 'shelf/shelf_screen.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CNTabBar(
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
        searchItem: CNTabBarSearchItem(
          placeholder: 'Search',
          onSearchChanged: (query) {
            // TODO: Implement search logic
          },
        ),
      ),
    );
  }
}
