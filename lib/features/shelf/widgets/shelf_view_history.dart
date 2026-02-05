import 'package:flutter/material.dart';
import 'shelf_header.dart';

class ShelfViewHistory extends StatelessWidget {
  const ShelfViewHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        ShelfHeader(title: '播放历史', onMorePressed: () {}),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '暂无播放历史',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
