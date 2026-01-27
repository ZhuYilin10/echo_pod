import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/audio/audio_handler.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';
import '../../features/ai_agent/ai_agent_screen.dart';
import '../../features/share/share_screen.dart';
import '../../features/player/playlist_screen.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final Episode episode;

  const PlayerScreen({super.key, required this.episode});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _aiSummary;
  bool _isSummarizing = false;
  bool _skipSilence = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    final audioHandler = ref.watch(audioHandlerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('正在播放'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShareScreen(episode: widget.episode)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined, color: Colors.amber),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AIAgentScreen(episode: widget.episode)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Artwork
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(
                        widget.episode.imageUrl ?? '',
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.podcasts, size: 80),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title & Podcast
                  Text(
                    widget.episode.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.episode.podcastTitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.deepPurpleAccent),
                  ),
                  const SizedBox(height: 24),
                  // Progress Bar
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream(audioHandler),
                    builder: (context, snapshot) {
                      // print("state: ${snapshot.data?.position}");
                      final state = snapshot.data;
                      return ProgressBar(
                        progress: state?.position ?? Duration.zero,
                        buffered: state?.bufferedPosition ?? Duration.zero,
                        total: state?.duration ?? Duration.zero,
                        onSeek: (duration) => audioHandler.seek(duration),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Controls
                  StreamBuilder<PlaybackState>(
                    stream: audioHandler.playbackState,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final playing = state?.playing ?? false;
                      final speed = state?.speed ?? 1.0;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  final newSpeed = speed >= 2.0 ? 0.5 : speed + 0.5;
                                  audioHandler.setSpeed(newSpeed);
                                },
                                child: Text('${speed}x', style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.replay_10, size: 32),
                                onPressed: () => audioHandler.seek(state!.updatePosition - const Duration(seconds: 10)),
                              ),
                              IconButton(
                                iconSize: 64,
                                icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                                onPressed: playing ? audioHandler.pause : audioHandler.play,
                              ),
                              IconButton(
                                icon: const Icon(Icons.forward_30, size: 32),
                                onPressed: () => audioHandler.seek(state!.updatePosition + const Duration(seconds: 30)),
                              ),
                              IconButton(
                                icon: Icon(_skipSilence ? Icons.bolt_rounded : Icons.bolt_outlined, color: _skipSilence ? Colors.amber : Colors.grey),
                                onPressed: () {
                                  setState(() => _skipSilence = !_skipSilence);
                                  // setSkipSilence is not supported by just_audio AudioPlayer
                                  // audioHandler.setSkipSilence(_skipSilence);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('跳过沉默功能暂不可用'), duration: Duration(seconds: 1)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.playlist_play_rounded, color: Colors.deepPurpleAccent),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaylistScreen())),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.deepPurpleAccent,
                    tabs: const [
                      Tab(text: 'AI 总结'),
                      Tab(text: '节目详情'),
                    ],
                  ),
                  // Tab Content
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSummaryTab(),
                        _buildShowNotesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSummarizing)
            const Center(child: CircularProgressIndicator())
          else if (_aiSummary != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_aiSummary!, style: const TextStyle(fontSize: 15, height: 1.6)),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AIAgentScreen(episode: widget.episode)),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: const Text('针对内容深度提问'),
                  ),
                ),
              ],
            )
          else
            Center(
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, size: 48, color: Colors.amber.withOpacity(0.5)),
                  const SizedBox(height: 12),
                  const Text('想快速了解这集讲了什么？', style: TextStyle(color: Colors.grey)),
                  TextButton(onPressed: _generateSummary, child: const Text('立即生成 AI 总结')),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShowNotesTab() {
    final audioHandler = ref.read(audioHandlerProvider);
    
    // Regex to find timestamps like 12:34 or 01:23:45
    final timestampRegex = RegExp(r'(\d{1,2}:)?\d{1,2}:\d{2}');
    
    String processedNotes = widget.episode.description ?? '本期节目暂无详细介绍';
    
    // Wrap timestamps in clickable links
    processedNotes = processedNotes.splitMapJoin(
      timestampRegex,
      onMatch: (m) {
        final time = m.group(0)!;
        return '<a href="seek://$time" style="color: #BB86FC; text-decoration: none; font-weight: bold;">$time</a>';
      },
      onNonMatch: (n) => n,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: HtmlWidget(
        processedNotes,
        onTapUrl: (url) {
          if (url.startsWith('seek://')) {
            final timeStr = url.replaceFirst('seek://', '');
            final duration = _parseTimestamp(timeStr);
            audioHandler.seek(duration);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已跳转至 $timeStr'), duration: const Duration(seconds: 1)),
            );
            return true;
          }
          return false;
        },
        textStyle: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
      ),
    );
  }

  Duration _parseTimestamp(String time) {
    final parts = time.split(':');
    if (parts.length == 3) {
      return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]), seconds: int.parse(parts[2]));
    } else if (parts.length == 2) {
      return Duration(minutes: int.parse(parts[0]), seconds: int.parse(parts[1]));
    }
    return Duration(seconds: int.tryParse(time) ?? 0);
  }

  Stream<PositionData> _positionDataStream(EchoPodAudioHandler audioHandler) {
    return Rx.combineLatest3<PlaybackState, MediaItem?, void, PositionData>(
        audioHandler.playbackState,
        audioHandler.mediaItem,
        Stream.periodic(const Duration(milliseconds: 200)),
        (playbackState, mediaItem, _) {
      Duration position = playbackState.updatePosition;
      if (playbackState.playing) {
        final now = DateTime.now();
        // Calculate the elapsed time since the last update
        final elapsed = now.difference(playbackState.updateTime);
        // Add the elapsed time * speed to the base position
        position += elapsed * playbackState.speed;
      }
      return PositionData(
        position,
        playbackState.bufferedPosition,
        mediaItem?.duration ?? Duration.zero,
      );
    });
  }

}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
