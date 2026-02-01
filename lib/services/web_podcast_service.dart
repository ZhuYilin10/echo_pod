import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_session/audio_session.dart';
import 'bilibili_parser_service.dart';

// --- Video Podcast State ---

class VideoPodcastState {
  final String? originalUrl;
  final String? videoUrl; // The resolved MP4 url
  final String? coverUrl; // Cover Art URL
  final String? title;
  final String? author;
  final String? authorAvatar;
  final String? description;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;
  final String? error;
  final bool isExpanded;

  VideoPodcastState({
    this.originalUrl,
    this.videoUrl,
    this.coverUrl,
    this.title,
    this.author,
    this.authorAvatar,
    this.description,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
    this.error,
    this.isExpanded = false,
  });

  VideoPodcastState copyWith({
    String? originalUrl,
    String? videoUrl,
    String? coverUrl,
    String? title,
    String? author,
    String? authorAvatar,
    String? description,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    String? error,
    bool? isExpanded,
  }) {
    return VideoPodcastState(
      originalUrl: originalUrl ?? this.originalUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      title: title ?? this.title,
      author: author ?? this.author,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      description: description ?? this.description,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

// --- Video Podcast Controller ---

class VideoPodcastController extends StateNotifier<VideoPodcastState> {
  VideoPodcastController() : super(VideoPodcastState());

  VideoPlayerController? _videoController;
  final BilibiliParserService _parser = BilibiliParserService();
  Timer? _positionTimer;

  Future<void> loadUrl(String url) async {
    try {
      state = state.copyWith(
        originalUrl: url,
        isLoading: true,
        error: null,
        isExpanded: true, // Auto expand
        isPlaying: false,
        position: Duration.zero,
        duration: Duration.zero,
      );

      // 1. Parse URL
      final info = await _parser.parse(url);

      // 2. Dispose old controller
      _disposeController();

      // 3. Init new controller
      if (info.videoUrl == null) throw Exception("Video URL not found");

      // Ensure AudioSession is configured for background playback
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(info.videoUrl!),
        httpHeaders: {
          'Referer': url,
          'User-Agent':
              'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
        },
      );
      _videoController = controller;

      await controller.initialize();

      // 4. Update State
      state = state.copyWith(
        videoUrl: info.videoUrl,
        coverUrl: info.coverUrl,
        title: info.title,
        author: info.author,
        authorAvatar: info.authorAvatar,
        description: info.description,
        isLoading: false,
        duration: controller.value.duration,
        isPlaying: true,
      );

      // 5. Auto Play
      await controller.play();
      _startPositionTimer();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> play() async {
    await _videoController?.play();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> pause() async {
    await _videoController?.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> seek(Duration position) async {
    await _videoController?.seekTo(position);
    state = state.copyWith(position: position);
  }

  void expand() {
    state = state.copyWith(isExpanded: true);
  }

  void collapse() {
    state = state.copyWith(isExpanded: false);
  }

  Future<void> close() async {
    _disposeController();
    state = VideoPodcastState();
  }

  void _disposeController() {
    _positionTimer?.cancel();
    _videoController?.dispose();
    _videoController = null;
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        final value = _videoController!.value;
        // Check if finished
        if (value.position >= value.duration &&
            value.duration > Duration.zero) {
          state = state.copyWith(isPlaying: false, position: value.duration);
        } else {
          state = state.copyWith(
            position: value.position,
            duration: value.duration,
            isPlaying: value.isPlaying,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}

final videoPodcastControllerProvider =
    StateNotifierProvider<VideoPodcastController, VideoPodcastState>((ref) {
  return VideoPodcastController();
});

// --- Native Video Player Widget ---

class VideoPlayerWidget extends ConsumerWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoPodcastControllerProvider);
    final controller = ref.watch(videoPodcastControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Cover
            if (state.coverUrl != null &&
                (controller._videoController == null ||
                    !controller._videoController!.value.isInitialized))
              Image.network(state.coverUrl!, fit: BoxFit.cover),

            // Video Player or Loading
            state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white))
                : state.error != null
                    ? Center(
                        child: Text('Error: ${state.error}',
                            style: const TextStyle(color: Colors.red)))
                    : _NativePlayerView(
                        controller: controller._videoController,
                      ),
          ],
        ),
      ),
    );
  }
}

class _NativePlayerView extends StatelessWidget {
  final VideoPlayerController? controller;

  const _NativePlayerView({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const SizedBox();
    }
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: VideoPlayer(controller!),
    );
  }
}
