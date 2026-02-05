import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import 'quote_card.dart';
import 'package:m3e_collection/m3e_collection.dart';

class ShareScreen extends ConsumerStatefulWidget {
  final Episode episode;

  const ShareScreen({super.key, required this.episode});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  String? _quote;
  bool _isLoading = false;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    // Auto-generate on entry
    _generateQuote();
  }

  void _generateQuote() async {
    setState(() => _isLoading = true);

    final aiService = ref.read(aiServiceProvider);
    final result = await aiService.extractGoldenSentence(
      widget.episode.title,
      widget.episode.description ?? '',
    );

    if (mounted) {
      setState(() {
        _quote = result;
        _isLoading = false;
      });
    }
  }

  void _shareImage() async {
    final image = await _screenshotController.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/share_quote.png').create();
    await imagePath.writeAsBytes(image);

    await Share.shareXFiles([XFile(imagePath.path)],
        text: '来自 EchoPod AI 的金句分享');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成金句卡片'),
        centerTitle: true,
        actions: [
          if (_quote != null && !_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _generateQuote,
              tooltip: '换一句',
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: _isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicatorM3E(
                              size: CircularProgressM3ESize.m,
                              activeColor:
                                  Theme.of(context).colorScheme.primary),
                          SizedBox(height: 20),
                          Text('AI 正在为您打磨金句...',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : _quote != null
                        ? Screenshot(
                            controller: _screenshotController,
                            child: QuoteCard(
                              episode: widget.episode,
                              quote: _quote!,
                              author: '本集核心观点',
                            ),
                          )
                        : const Text('生成失败，请重试'),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('取消'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          (_quote != null && !_isLoading) ? _shareImage : null,
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('分享朋友圈'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SafeArea(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
