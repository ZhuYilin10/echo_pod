import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:audio_service/audio_service.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../ai_agent/ai_agent_screen.dart';

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

  String _processDescription(String? description) {
    if (description == null) return '';
    // Regex to find timestamps like 12:34 or 1:23:45
    final regExp = RegExp(r'(\d{1,2}:)?\d{1,2}:\d{2}');
    return description.replaceAllMapped(regExp, (match) {
      final timestamp = match.group(0)!;
      return '<a href="seek://$timestamp">$timestamp</a>';
    });
  }

  Duration _parseTimestamp(String timestamp) {
    final parts = timestamp.split(':');
    if (parts.length == 3) {
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]),
      );
    } else if (parts.length == 2) {
      return Duration(
        minutes: int.parse(parts[0]),
        seconds: int.parse(parts[1]),
      );
    }
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('订阅'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal.withOpacity(0.1),
              foregroundColor: Colors.tealAccent,
            ),
          ),
          const SizedBox(width: 16),
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
                Hero(
                  tag: 'episode_artwork_${widget.episode.guid}',
                  child: Container(
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.episode.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.episode.podcastTitle} >',
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    final isCurrent = snapshot.data?.id == widget.episode.guid;
                    return StreamBuilder<PlaybackState>(
                      stream: audioHandler.playbackState,
                      builder: (context, playbackSnapshot) {
                        final playing = playbackSnapshot.data?.playing ?? false;
                        final isBusy = isCurrent && playing;
                        
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isCurrent)
                              SizedBox(
                                width: 54,
                                height: 54,
                                child: CircularProgressIndicator(
                                  value: _calculateProgress(playbackSnapshot.data, snapshot.data),
                                  strokeWidth: 2,
                                  color: Colors.tealAccent,
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                isBusy ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                size: 48,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (isCurrent) {
                                  playing ? audioHandler.pause() : audioHandler.play();
                                } else {
                                  audioHandler.playEpisode(widget.episode);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.tealAccent),
                const SizedBox(width: 4),
                Text(
                  '${_formatDuration(widget.episode.duration)} · ${widget.episode.pubDate?.year}/${widget.episode.pubDate?.month}/${widget.episode.pubDate?.day}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
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
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(_aiSummary!, style: const TextStyle(color: Colors.white, height: 1.5)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AIAgentScreen(episode: widget.episode)),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('与 AI 助手深度交流'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.tealAccent,
                      side: const BorderSide(color: Colors.tealAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            const Text('本期节目的主要内容有：', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            const SizedBox(height: 12),
            HtmlWidget(
              _processDescription(widget.episode.description),
              onTapUrl: (url) {
                if (url.startsWith('seek://')) {
                  final timestamp = url.substring(7);
                  final duration = _parseTimestamp(timestamp);
                  audioHandler.seek(duration);
                  audioHandler.play();
                  return true;
                }
                return false;
              },
              customStylesBuilder: (element) {
                // Force white color for text and ensure backgrounds are transparent
                // This targets the element itself and all its children by inheritance
                return {
                  'color': 'white',
                  'background-color': 'transparent',
                  'font-weight': 'normal',
                };
              },
              textStyle: const TextStyle(height: 1.8, color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  double? _calculateProgress(PlaybackState? state, MediaItem? item) {
    if (state == null || item == null || item.duration == null || item.duration == Duration.zero) {
      return null;
    }
    return state.position.inMilliseconds / item.duration!.inMilliseconds;
  }

  String _formatDuration(String? durationStr) {
    if (durationStr == null) return '未知时长';
    try {
      if (durationStr.contains(':')) {
        final parts = durationStr.split(':');
        if (parts.length == 3) {
          final hours = int.parse(parts[0]);
          final minutes = int.parse(parts[1]);
          if (hours > 0) return '$hours小时$minutes分钟';
          return '$minutes分钟';
        } else if (parts.length == 2) {
          return '${int.parse(parts[0])}分钟';
        }
      }
      final seconds = double.tryParse(durationStr)?.toInt() ?? 0;
      if (seconds > 0) {
        final minutes = (seconds / 60).floor();
        return '$minutes分钟';
      }
    } catch (_) {}
    return durationStr;
  }
}
