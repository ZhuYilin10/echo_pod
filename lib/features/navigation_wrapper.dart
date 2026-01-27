import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'discovery/discovery_screen.dart';
import 'search/search_screen.dart';
import 'player/mini_player.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoveryScreen(),
    const SearchScreen(),
  ];

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
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
        ],
      ),
    );
  }
}
