import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/providers.dart';
import '../services/web_podcast_service.dart';
import 'home/home_screen.dart';
import 'discovery/discovery_screen.dart';
import 'player/mini_player.dart';

class MainNavigationWrapper extends ConsumerStatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  ConsumerState<MainNavigationWrapper> createState() =>
      _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends ConsumerState<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoveryScreen(),
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
      body: Column(
        children: [
          Expanded(child: _screens[_currentIndex]),
          const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepPurpleAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '我的'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: '发现'),
        ],
      ),
    );
  }
}
