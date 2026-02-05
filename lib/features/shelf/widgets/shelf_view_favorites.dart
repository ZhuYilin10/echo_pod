import 'package:flutter/material.dart';
import 'shelf_header.dart';

class ShelfViewFavorites extends StatelessWidget {
  const ShelfViewFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        ShelfHeader(title: '我的收藏', onMorePressed: () {}),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '暂无收藏内容',
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
