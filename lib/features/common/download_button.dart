import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';

class DownloadButton extends ConsumerStatefulWidget {
  final Episode episode;
  final Color? color;
  final double size;

  const DownloadButton({
    super.key,
    required this.episode,
    this.color,
    this.size = 24.0,
  });

  @override
  ConsumerState<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends ConsumerState<DownloadButton> {
  bool _isActionInProgress = false;

  @override
  Widget build(BuildContext context) {
    if (widget.episode.audioUrl == null) return const SizedBox();

    final downloadedAsync = ref.watch(downloadedEpisodesProvider);
    final activeDownloadsAsync = ref.watch(activeDownloadsProvider);

    return downloadedAsync.when(
      data: (downloadedEpisodes) {
        final isDownloaded =
            downloadedEpisodes.any((e) => e.guid == widget.episode.guid);

        if (isDownloaded) {
          return IconButton(
            icon: Icon(Icons.download_done_rounded,
                color: widget.color ?? Colors.tealAccent, size: widget.size),
            onPressed: () => _handleDelete(context),
            tooltip: '已下载 (点击删除)',
          );
        }

        // Check if currently downloading
        double? progress;
        activeDownloadsAsync.whenData((active) {
          if (active.containsKey(widget.episode.audioUrl!)) {
            progress = active[widget.episode.audioUrl!];
          }
        });

        if (progress != null && progress! >= 0 && progress! < 1.0) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              color: widget.color ?? Colors.tealAccent,
            ),
          );
        }

        if (_isActionInProgress) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.color ?? Colors.grey,
            ),
          );
        }

        return IconButton(
          icon: Icon(Icons.download_rounded,
              color: widget.color ?? Colors.white, size: widget.size),
          onPressed: _handleDownload,
          tooltip: '下载',
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  void _handleDownload() async {
    if (widget.episode.audioUrl == null) return;

    setState(() => _isActionInProgress = true);
    try {
      final downloadService = ref.read(downloadServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      await downloadService.downloadEpisode(widget.episode.audioUrl!, (p) {});

      // Save complete metadata after successful download
      await storageService.saveDownload(widget.episode);

      ref.invalidate(downloadedEpisodesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('下载完成')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('下载失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isActionInProgress = false);
      }
    }
  }

  void _handleDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除下载'),
        content: const Text('确定要删除该单集的已下载文件吗？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true && widget.episode.audioUrl != null) {
      final downloadService = ref.read(downloadServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      await downloadService.deleteDownload(widget.episode.audioUrl!);
      await storageService.removeDownload(widget.episode.guid);

      ref.invalidate(downloadedEpisodesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('已删除')));
      }
    }
  }
}
