import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import 'shelf_header.dart';
import 'shelf_download_card.dart';
import 'package:m3e_collection/m3e_collection.dart';

class ShelfViewDownloaded extends ConsumerWidget {
  const ShelfViewDownloaded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadedEpisodesProvider);

    return downloadsAsync.when(
      data: (episodes) {
        if (episodes.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_for_offline_rounded,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '暂无下载剧集',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            ShelfHeader(
              title: '已下载',
              onMorePressed: () {},
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ShelfDownloadCard(episode: episodes[index]),
                childCount: episodes.length,
              ),
            ),
          ],
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
        child: Center(child: Text('加载失败: $e')),
      ),
    );
  }
}
