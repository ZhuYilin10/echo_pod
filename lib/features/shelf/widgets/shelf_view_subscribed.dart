import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/podcast.dart';
import 'shelf_header.dart';
import 'shelf_podcast_card.dart';
import 'package:m3e_collection/m3e_collection.dart';

class ShelfViewSubscribed extends StatelessWidget {
  final AsyncValue<List<Podcast>> subscriptionsAsync;

  const ShelfViewSubscribed({
    super.key,
    required this.subscriptionsAsync,
  });

  @override
  Widget build(BuildContext context) {
    return subscriptionsAsync.when(
      data: (podcasts) {
        if (podcasts.isEmpty) {
          return _buildEmptyStateSliver();
        }
        return SliverMainAxisGroup(
          slivers: [
            ShelfHeader(
              title: '已订阅节目',
              moreText: '查看全部',
              onMorePressed: () {},
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ShelfPodcastCard(podcast: podcasts[index]),
                  childCount: podcasts.length,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicatorM3E(
              size: CircularProgressM3ESize.m,
              activeColor: Theme.of(context).colorScheme.primary),
        ),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(child: Text('加载失败: $error')),
      ),
    );
  }

  Widget _buildEmptyStateSliver() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.album_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '暂无订阅内容',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
