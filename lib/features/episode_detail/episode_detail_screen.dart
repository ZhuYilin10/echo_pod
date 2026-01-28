import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../player/player_screen.dart';

class EpisodeDetailScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const EpisodeDetailScreen({super.key, required this.episode});

  @override
  ConsumerState<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends ConsumerState<EpisodeDetailScreen> {
  String? _aiSummary;
  bool _isSummarizing = false;

  void _generateSummary() async {
    setState(() => _isSummarizing = true);
    final aiService = ref.read(aiServiceProvider);
    final summary = await aiService.getEpisodeSummary(
      widget.episode.title,
      widget.episode.description ?? '',
    );
    if (mounted) {
      setState(() {
        _aiSummary = summary;
        _isSummarizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {}, // TODO: Subscribe podcast logic
            icon: const Icon(Icons.add, size: 18),
            label: const Text('订阅'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal.withOpacity(0.1),
              foregroundColor: Colors.tealAccent,
            ),
          ),
          IconButton(icon: const Icon(Icons.ios_share_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.episode.imageUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.episode.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.episode.podcastTitle} >',
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, size: 48, color: Colors.white),
                  onPressed: () {
                    ref.read(audioHandlerProvider).playEpisode(widget.episode);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlayerScreen(episode: widget.episode)),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.blueAccent),
                const SizedBox(width: 4),
                Text(
                  '剩余${widget.episode.duration ?? '未知'}分钟 · ${widget.episode.pubDate?.year}/${widget.episode.pubDate?.month}/${widget.episode.pubDate?.day}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Spacer(),
                const Icon(Icons.sort, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.favorite_border, color: Colors.blueAccent, size: 20),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateSummary,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('总结单集'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isSummarizing)
              const Center(child: CircularProgressIndicator())
            else if (_aiSummary != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_aiSummary!),
              ),
            const SizedBox(height: 24),
            const Text('本期节目的主要内容有：', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            HtmlWidget(
              widget.episode.description ?? '',
              textStyle: const TextStyle(height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}
