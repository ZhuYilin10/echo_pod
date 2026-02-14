import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../services/sharing/sharing_service.dart';

/// OPML 导入页面 - 显示播客列表并支持选择导入
class OpmlImportScreen extends ConsumerStatefulWidget {
  final List<OpmlPodcastInfo> podcasts;

  const OpmlImportScreen({
    super.key,
    required this.podcasts,
  });

  @override
  ConsumerState<OpmlImportScreen> createState() => _OpmlImportScreenState();
}

class _OpmlImportScreenState extends ConsumerState<OpmlImportScreen> {
  late List<OpmlPodcastInfo> _podcasts;
  bool _isImporting = false;
  int _importedCount = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _podcasts = List.from(widget.podcasts);
  }

  /// 全选/取消全选
  void _toggleSelectAll(bool selectAll) {
    setState(() {
      for (var i = 0; i < _podcasts.length; i++) {
        _podcasts[i] = _podcasts[i].copyWith(selected: selectAll);
      }
    });
  }

  /// 切换单个选择
  void _togglePodcast(int index, bool selected) {
    setState(() {
      _podcasts[index] = _podcasts[index].copyWith(selected: selected);
    });
  }

  /// 开始导入
  Future<void> _startImport() async {
    final selectedPodcasts = _dedupeByFeedUrl(
      _podcasts.where((p) => p.selected).toList(),
    );
    if (selectedPodcasts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一个播客')),
      );
      return;
    }

    setState(() {
      _isImporting = true;
      _totalCount = selectedPodcasts.length;
      _importedCount = 0;
    });

    final podcastService = ref.read(podcastServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    final existingFeedUrls = (await storageService.getSubscriptions())
        .map((podcast) => SharingService.normalizeFeedUrl(podcast.feedUrl))
        .where((url) => url.isNotEmpty)
        .toSet();

    int success = 0;
    int skippedExisting = 0;
    final failures = <String>[];

    // 并发限制
    const batchSize = 5;
    for (var i = 0; i < selectedPodcasts.length; i += batchSize) {
      final end = (i + batchSize < selectedPodcasts.length)
          ? i + batchSize
          : selectedPodcasts.length;
      final batch = selectedPodcasts.sublist(i, end);

      await Future.wait(batch.map((info) async {
        final normalizedUrl = SharingService.normalizeFeedUrl(info.feedUrl);
        if (existingFeedUrls.contains(normalizedUrl)) {
          skippedExisting++;
          return;
        }

        try {
          final podcast =
              await podcastService.fetchPodcastMetadata(normalizedUrl);
          if (podcast != null) {
            await storageService.subscribe(podcast);
            existingFeedUrls.add(normalizedUrl);
            success++;
          } else {
            failures.add('${info.title}：无法解析订阅源');
          }
        } catch (e) {
          failures.add('${info.title}：$e');
        }
      }));

      if (mounted) {
        setState(() {
          _importedCount = i + batch.length;
        });
      }
    }

    // 刷新订阅列表
    ref.invalidate(subscriptionsProvider);
    ref.invalidate(unifiedRecentEpisodesProvider);

    if (mounted) {
      final navigator = Navigator.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '导入完成: 成功 $success/${selectedPodcasts.length}'
            '${skippedExisting > 0 ? '，已存在 $skippedExisting' : ''}'
            '${failures.isNotEmpty ? '，失败 ${failures.length}' : ''}',
          ),
        ),
      );
      if (failures.isNotEmpty) {
        await _showFailureDetails(failures);
      }
      if (!mounted) return;
      // 返回上一页
      navigator.pop();
    }
  }

  List<OpmlPodcastInfo> _dedupeByFeedUrl(List<OpmlPodcastInfo> podcasts) {
    final seen = <String>{};
    final deduped = <OpmlPodcastInfo>[];
    for (final podcast in podcasts) {
      final url = SharingService.normalizeFeedUrl(podcast.feedUrl);
      if (url.isEmpty) continue;
      if (seen.add(url)) {
        deduped.add(podcast.copyWith(feedUrl: url));
      }
    }
    return deduped;
  }

  Future<void> _showFailureDetails(List<String> failures) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('部分导入失败'),
        content: SizedBox(
          width: double.maxFinite,
          height: 260,
          child: ListView.builder(
            itemCount: failures.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                failures[index],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _podcasts.where((p) => p.selected).length;
    final allSelected =
        selectedCount == _podcasts.length && _podcasts.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('导入订阅'),
        leading: _isImporting
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          if (!_isImporting)
            TextButton(
              onPressed: () => _toggleSelectAll(!allSelected),
              child: Text(allSelected ? '取消全选' : '全选'),
            ),
        ],
      ),
      body: _isImporting ? _buildImportingView() : _buildPodcastList(),
      bottomNavigationBar: _isImporting
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton(
                  onPressed: selectedCount > 0 ? _startImport : null,
                  child: Text('导入选中的 $selectedCount 个播客'),
                ),
              ),
            ),
    );
  }

  /// 导入中进度视图
  Widget _buildImportingView() {
    final progress = _totalCount > 0 ? _importedCount / _totalCount : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '正在导入...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            Text(
              '$_importedCount / $_totalCount',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// 播客列表视图
  Widget _buildPodcastList() {
    if (_podcasts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.podcasts_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('未找到播客订阅'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _podcasts.length,
      itemBuilder: (context, index) {
        final podcast = _podcasts[index];
        return CheckboxListTile(
          value: podcast.selected,
          onChanged: (value) => _togglePodcast(index, value ?? false),
          title: Text(
            podcast.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            podcast.feedUrl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          secondary: const CircleAvatar(
            child: Icon(Icons.podcasts),
          ),
        );
      },
    );
  }
}
