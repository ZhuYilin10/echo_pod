import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import 'quote_card.dart';

class ShareScreen extends ConsumerStatefulWidget {
  final Episode episode;

  const ShareScreen({super.key, required this.episode});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  String? _quote;
  bool _isLoading = false;

  void _generateQuote() async {
    setState(() => _isLoading = true);
    
    final aiService = ref.read(aiServiceProvider);
    // Ask AI to find a "Golden Sentence" from the description/title
    final result = await aiService.getEpisodeSummary(
      '提取金句: ${widget.episode.title}',
      '请从以下播客描述中提取一句最感人或最具启发性的话作为金句，如果找不到，请根据内容润色出一句。描述: ${widget.episode.description}',
    );

    if (mounted) {
      setState(() {
        _quote = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成金句卡片'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_quote != null)
                QuoteCard(
                  episode: widget.episode,
                  quote: _quote!,
                  author: 'EchoPod AI 精选',
                )
              else
                Column(
                  children: [
                    const Icon(Icons.auto_awesome, size: 80, color: Colors.amber),
                    const SizedBox(height: 24),
                    const Text('让 AI 为这一集提炼金句', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('生成精美的图片分享到朋友圈', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              const SizedBox(height: 48),
              if (!_isLoading)
                ElevatedButton.icon(
                  onPressed: _generateQuote,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(_quote == null ? '立即生成' : '换一句'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              if (_quote != null) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('图片已保存到相册 (模拟)')),
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('保存图片'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
