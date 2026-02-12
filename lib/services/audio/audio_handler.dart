import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/models/episode.dart';
import '../platform/live_activity_service.dart';
import '../storage/storage_service.dart';
import '../web_podcast_service.dart'; // Import WebAudioController
import '../freshrss_service.dart';

class EchoPodAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final LiveActivityService _liveActivityService;
  final StorageService _storageService;
  bool _liveActivityActive = false;
  Episode? _currentEpisode;
  Timer? _saveTimer;
  Timer? _sleepTimer;
  final _sleepTimerController = StreamController<Duration?>.broadcast();
  bool _isSkipSilenceEnabled = false;
  Duration _totalSavedTime = Duration.zero;
  final _timeSavedController = BehaviorSubject<Duration>.seeded(Duration.zero);

  // Current Episode Stream - 当前播放的单集
  final _currentEpisodeController = BehaviorSubject<Episode?>.seeded(null);

  // Web Audio Support
  VideoPodcastController? _webController;
  StreamSubscription? _webSubscription;
  bool _isWebMode = false;

  double _currentSpeed = 1.0;

  EchoPodAudioHandler(this._liveActivityService, this._storageService) {
    _player.playbackEventStream.map(_transformEvent).listen((state) {
      if (!_isWebMode) {
        playbackState.add(state);
      }
    });
    _player.setAudioSource(_playlist);

    _player.currentIndexStream.listen((index) async {
      if (index != null && index < queue.value.length) {
        final item = queue.value[index];
        mediaItem.add(item);
        if (item.extras != null) {
          final episode = Episode.fromJson(item.extras!);
          _currentEpisode = episode;
          _currentEpisodeController.add(episode);
          _startSaveTimer();

          // Apply speed explicitly
          await _applySpeedForEpisode(episode);
        }
      }
    });

    // Handle episode completion
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleEpisodeCompleted();
      }
    });

    // Listen to position changes to update Live Activity and track saved time
    DateTime? lastPositionUpdate;
    Duration? lastPosition;

    _player.durationStream.listen((duration) {
      if (duration != null && mediaItem.value != null) {
        if (mediaItem.value!.duration != duration) {
          mediaItem.add(mediaItem.value!.copyWith(duration: duration));
        }
      }
    });

    _player.positionStream.listen((position) {
      _updateLiveActivity(position);
      if (!_isWebMode) {
        // Update playback state with the current position to keep UI in sync
        playbackState.add(_transformEvent(_player.playbackEvent));
      }

      if (!_isWebMode &&
          _isSkipSilenceEnabled &&
          _player.playing &&
          lastPosition != null &&
          lastPositionUpdate != null) {
        final now = DateTime.now();
        final wallElapsedMs =
            now.difference(lastPositionUpdate!).inMilliseconds;
        final audioElapsedMs = (position - lastPosition!).inMilliseconds;
        final expectedElapsedMs = (wallElapsedMs * _currentSpeed).round();

        // If audio jumped forward more than expected (allowing for some jitter)
        // threshold 300ms jitter is safe for 1 second interval
        if (audioElapsedMs > expectedElapsedMs + 300) {
          final savedMs = audioElapsedMs - expectedElapsedMs;
          if (savedMs > 0 && savedMs < 10000) {
            // Limit to 10s jump to avoid seek confusion
            final saved = Duration(milliseconds: savedMs);
            _totalSavedTime += saved;
            _timeSavedController.add(_totalSavedTime);
            _storageService.addTimeSaved(saved);
          }
        }
      }
      lastPosition = position;
      lastPositionUpdate = DateTime.now();
    });

    // Listen to playing state changes
    _player.playingStream.listen((playing) {
      if (!_isWebMode) {
        if (!playing) {
          lastPosition = null;
          lastPositionUpdate = null;
        }
        _updateLiveActivity(_player.position);
      }
    });

    _player.speedStream.listen((speed) {
      // Sync back from player just in case, but usually we control it
      if ((_currentSpeed - speed).abs() > 0.05) {
        // Only update if significantly different, to avoid loop
        // _currentSpeed = speed;
        // Actually, let's keep _currentSpeed as authoritative for UI
      }
    });

    _init();
  }

  void setWebAudioController(VideoPodcastController controller) {
    _webController = controller;
    _webSubscription?.cancel();
    _webSubscription = controller.stream.listen((state) {
      if (!_isWebMode) return;

      // Sync Web State to AudioService State
      final playing = state.isPlaying;
      final position = state.position;
      final duration = state.duration;

      // Sync Metadata (Title, Author, Cover)
      // Check if we have new info that differs from current MediaItem
      final currentItem = mediaItem.value;
      if (currentItem != null && state.title != null) {
        if (currentItem.title != state.title ||
            (state.author != null && currentItem.artist != state.author) ||
            (state.coverUrl != null &&
                currentItem.artUri.toString() != state.coverUrl)) {
          // Create updated item
          // Note: "album" field is often used for Podcast Title/Author in this app
          // We map 'author' -> 'album' (display logic usually shows album as subtitle)
          mediaItem.add(currentItem.copyWith(
              title: state.title ?? currentItem.title,
              album: state.author ?? currentItem.album,
              artist: state.author, // Set artist explicitly too
              artUri: state.coverUrl != null
                  ? Uri.parse(state.coverUrl!)
                  : currentItem.artUri,
              duration: state.duration > Duration.zero
                  ? state.duration
                  : currentItem.duration,
              // We can also store description in extras if needed
              extras: {
                ...currentItem.extras ?? {},
                'description': state.description,
                'authorAvatar': state.authorAvatar,
              }));
        } else if (duration > Duration.zero &&
            currentItem.duration != duration) {
          // Just duration update
          mediaItem.add(currentItem.copyWith(duration: duration));
        }
      }

      // Update Live Activity
      _updateLiveActivity(position);

      playbackState.add(PlaybackState(
        controls: [
          // MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          // MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1],
        processingState: AudioProcessingState.ready,
        playing: playing,
        updatePosition: position,
        bufferedPosition: position, // Assume buffered matches pos for now
        speed: 1.0,
        queueIndex: 0,
      ));
    });
  }

  Future<void> _init() async {
    // Load saved time
    _totalSavedTime = await _storageService.getTotalTimeSaved();
    _timeSavedController.add(_totalSavedTime);

    // Load skip silence setting
    _isSkipSilenceEnabled = await _storageService.getSkipSilenceEnabled();
    await _player.setSkipSilenceEnabled(_isSkipSilenceEnabled);

    // Load history and populate queue
    try {
      final history = await _storageService.getPlayHistory();
      if (history.isNotEmpty) {
        final items = <MediaItem>[];
        for (var episode in history) {
          items.add(MediaItem(
            id: episode.guid,
            album: episode.podcastTitle,
            title: episode.title,
            artUri:
                episode.imageUrl != null ? Uri.parse(episode.imageUrl!) : null,
            duration: _parseDuration(episode.duration),
            extras: episode.toJson(),
          ));
        }

        // Check if queue was modified while we were loading
        if (queue.value.isNotEmpty) {
          print(
              'AudioHandler: Queue modified during init. Aborting history restore.');
          return;
        }

        // Update queue
        queue.add(items);

        // Add all to playlist audio source (lazily)
        for (var item in items) {
          await _playlist.add(await _buildAudioSource(item));
        }

        // Restore last played item (first in history) as current item
        // But do not auto-play
        if (items.isNotEmpty) {
          mediaItem.add(items.first);
          _currentEpisode = history.first;
          _currentEpisodeController.add(history.first);
          // seek to saved position for the first item
          final savedPosition =
              await _storageService.getPosition(history.first.guid);
          if (savedPosition > Duration.zero) {
            // We use a small delay or just set initial position if possible.
            // simplest is to just seek.
            // Note: _player might not be ready, so we might need to await loading first source?
            // Actually just setting mediaItem allows MiniPlayer to show it.
            // We can let user press play to resume.
            await _player.seek(savedPosition, index: 0);
          }
        }
      }
      // Always start the save timer on init if we have a current episode
      if (_currentEpisode != null) {
        _startSaveTimer();
      }
    } catch (e) {
      print('AudioHandler: Error initializing history: $e');
    }
  }

  void _startSaveTimer() {
    _saveTimer?.cancel();
    _saveTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _saveCurrentPosition();
    });
  }

  void _stopSaveTimer() {
    _saveTimer?.cancel();
    _saveTimer = null;
  }

  Future<void> _saveCurrentPosition() async {
    try {
      if (_currentEpisode != null) {
        await _storageService.savePosition(
            _currentEpisode!.guid, _player.position);
      }
    } catch (e) {
      print('Error saving position: $e');
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // LIFO logic for joining queue:
    // New additions should be #2 in line (index 1), immediately after current playing (#1).
    final currentQueue = queue.value;
    final existingIndex =
        currentQueue.indexWhere((item) => item.id == mediaItem.id);

    if (existingIndex != -1) {
      if (existingIndex == 0) return; // Already at top/playing
      await removeQueueItemAt(existingIndex);
    }

    // Insert at index 1 (right after currently playing)
    // If queue is empty, insert at 0
    final insertIndex = currentQueue.isEmpty ? 0 : 1;

    final source = await _buildAudioSource(mediaItem);
    await _playlist.insert(insertIndex, source);
    final newQueue = List<MediaItem>.from(queue.value)
      ..insert(insertIndex, mediaItem);
    queue.add(newQueue);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await _playlist.removeAt(index);
    final newQueue = List<MediaItem>.from(queue.value)..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
  }

  Future<AudioSource> _buildAudioSource(MediaItem item) async {
    final audioUrl = item.extras?['audioUrl'] as String? ?? item.id;
    final directory = await getApplicationDocumentsDirectory();
    // Use hashcode to prevent filename collisions (e.g. index.m3u8)
    final extension = audioUrl.split('/').last.split('?').first.split('.').last;
    final fileName = '${audioUrl.hashCode}.$extension';
    final localFile = File('${directory.path}/downloads/$fileName');

    if (localFile.existsSync()) {
      return AudioSource.file(localFile.path, tag: item);
    } else {
      // Use standard Uri source instead of LockCachingAudioSource to avoid potential
      // file system/encoding errors on iOS (err=-12864) which cause skipping.
      return AudioSource.uri(Uri.parse(audioUrl), tag: item);
    }
  }

  @override
  Future<void> play() async {
    if (_isWebMode) {
      await _webController?.play();
    } else {
      await _player.play();
    }
  }

  @override
  Future<void> pause() async {
    if (_isWebMode) {
      await _webController?.pause();
    } else {
      await _player.pause();
    }
  }

  @override
  Future<void> stop() async {
    if (_isWebMode) {
      _isWebMode = false;
      await _webController?.pause();
    }
    await _saveCurrentPosition();
    _stopSaveTimer();
    await _player.stop();
    if (_liveActivityActive) {
      await _liveActivityService.stopLiveActivity();
      _liveActivityActive = false;
    }
  }

  @override
  Future<void> seek(Duration position) async {
    if (_isWebMode) {
      await _webController?.seek(position);
    } else {
      await _player.seek(position);
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    print(
        '[SpeedLog] AudioHandler.setSpeed: Setting speed to $speed (WebMode: $_isWebMode)');
    if (!_isWebMode) {
      _currentSpeed = speed;
      // Optimistically update UI immediately
      playbackState.add(_transformEvent(_player.playbackEvent));

      await _player.setSpeed(speed);

      // Update again to ensure sync (optional but safe)
      // playbackState.add(_transformEvent(_player.playbackEvent));
    }
  }

  bool get isSkipSilenceEnabled => _isSkipSilenceEnabled;

  Future<void> setSkipSilence(bool enabled) async {
    _isSkipSilenceEnabled = enabled;
    await _storageService.saveSkipSilenceEnabled(enabled);
    await _player.setSkipSilenceEnabled(enabled);
  }

  Stream<bool> get skipSilenceStream => _player.skipSilenceEnabledStream;

  Stream<Duration> get totalTimeSavedStream => _timeSavedController.stream;

  Stream<Duration?> get sleepTimerStream => _sleepTimerController.stream;

  /// 当前播放的单集流 - 可在任何地方实时监听
  Stream<Episode?> get currentEpisodeStream => _currentEpisodeController.stream;

  /// 当前播放的单集（同步获取）
  Episode? get currentEpisode => _currentEpisode;

  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    if (duration == null) {
      _sleepTimerController.add(null);
      return;
    }

    var remaining = duration;
    _sleepTimerController.add(remaining);

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= const Duration(seconds: 1);
      if (remaining.inSeconds <= 0) {
        pause();
        _sleepTimer?.cancel();
        _sleepTimerController.add(null);
      } else {
        _sleepTimerController.add(remaining);
      }
    });
  }

  void _handleEpisodeCompleted() async {
    if (queue.value.isNotEmpty) {
      final completedEpisode = _currentEpisode;

      // Notify FreshRSS if applicable
      if (completedEpisode != null &&
          completedEpisode.podcastFeedUrl.startsWith('freshrss://')) {
        print(
            '[FreshRSS] Marking episode as read on server: ${completedEpisode.guid}');
        // We don't await this to avoid blocking the queue transition
        _storageService.getFreshRssConfig().then((config) {
          if (config['url'] != null) {
            final frService = FreshRssService();
            frService.configure(
                config['url']!, config['user']!, config['pass']!);
            frService.markAsRead(completedEpisode.guid);
          }
        });
      }

      // Current playing is at index 0. Remove it.
      await removeQueueItemAt(0);

      // If there's more in the queue, start the new index 0
      if (queue.value.isNotEmpty) {
        await _player.seek(Duration.zero, index: 0);
        await play();
      } else {
        _currentEpisode = null;
        _currentEpisodeController.add(null);
        mediaItem.add(null);
        _stopSaveTimer();
      }
    }
  }

  Future<void> playEpisode(Episode episode, {bool autoPlay = true}) async {
    // Check for Web Mode OR Bilibili/YouTube Video Link
    final isBilibiliVideo = episode.audioUrl != null &&
        (episode.audioUrl!.contains('bilibili.com') ||
            episode.audioUrl!.contains('youtube.com'));

    if (episode.guid.startsWith('web_') || isBilibiliVideo) {
      _isWebMode = true;

      // Stop local player to release focus (but we keep the session technically)
      // Actually we should pause just_audio so it doesn't fight.
      if (_player.playing) await _player.pause();

      // Notify System
      final item = MediaItem(
        id: episode.guid,
        album: episode.podcastTitle,
        title: episode.title,
        artUri: episode.imageUrl != null ? Uri.parse(episode.imageUrl!) : null,
        duration: null, // Unknown initially
        extras: episode.toJson(),
      );
      mediaItem.add(item);
      _currentEpisode = episode;
      _currentEpisodeController.add(episode);

      // 记录到播放历史
      await _storageService.addToHistory(episode);

      // Load URL in WebView (Video Player)
      if (episode.audioUrl != null) {
        await _webController?.loadUrl(episode.audioUrl!);
        // NOTE: The web controller plays automatically in its logic or we can request it
        if (autoPlay) {
          // Give it a moment or rely on the web page to start?
          // Our WebView logic has `video.play()` on load.
          await _webController?.play();
        }
      }
      return;
    }

    // Normal Mode
    if (_isWebMode) {
      _isWebMode = false;
      await _webController?.pause();
    }

    if (episode.audioUrl == null || episode.audioUrl!.isEmpty) return;

    try {
      // Save current position of the episode we're about to leave
      await _saveCurrentPosition();

      final item = MediaItem(
        id: episode.guid,
        album: episode.podcastTitle,
        title: episode.title,
        artUri: episode.imageUrl != null ? Uri.parse(episode.imageUrl!) : null,
        duration: _parseDuration(episode.duration),
        extras: episode.toJson(),
      );

      final currentQueue = queue.value;
      final existingIndex =
          currentQueue.indexWhere((i) => i.id == episode.guid);

      if (existingIndex == 0) {
        // Already playing this one, just ensure it's playing
        if (autoPlay) await play();
      } else {
        if (existingIndex > 0) {
          // Exists elsewhere, move it to top
          await removeQueueItemAt(existingIndex);
        }

        // Insert at index 0. This pushes the current playing (if any) to index 1.
        final source = await _buildAudioSource(item);
        await _playlist.insert(0, source);
        final newQueue = List<MediaItem>.from(queue.value)..insert(0, item);
        queue.add(newQueue);

        // Switch playback to the new index 0
        await _player.seek(Duration.zero, index: 0);

        _currentEpisode = episode;
        _currentEpisodeController.add(episode);
        mediaItem.add(item);

        // Restore position for this episode
        final savedPosition = await _storageService.getPosition(episode.guid);
        if (savedPosition > Duration.zero) {
          await _player.seek(savedPosition);
        }

        if (autoPlay) await play();

        await _storageService.addToHistory(episode);
        _startSaveTimer();

        // Explicitly apply speed for the new episode to ensure it's set
        // even if the stream listener is slightly delayed or we are just resuming.
        await _applySpeedForEpisode(episode);
      }
    } catch (e) {
      print('Error playing episode: $e');
    }
  }

  Future<void> _updateLiveActivity(Duration position) async {
    if (!_liveActivityActive || mediaItem.value == null) return;

    final duration = mediaItem.value!.duration;
    if (duration == null || duration.inSeconds == 0) return;

    final progress = position.inSeconds / duration.inSeconds;

    await _liveActivityService.updateLiveActivity(
      progress: progress.clamp(0.0, 1.0),
      isPlaying: _player.playing,
    );
  }

  Duration? _parseDuration(String? duration) {
    if (duration == null) return null;

    int parsePart(String part) {
      if (part.contains('.')) {
        return double.tryParse(part)?.toInt() ?? 0;
      }
      return int.tryParse(part) ?? 0;
    }

    if (duration.contains(':')) {
      final parts = duration.split(':');
      if (parts.length == 3) {
        return Duration(
          hours: parsePart(parts[0]),
          minutes: parsePart(parts[1]),
          seconds: parsePart(parts[2]),
        );
      } else if (parts.length == 2) {
        return Duration(
          minutes: parsePart(parts[0]),
          seconds: parsePart(parts[1]),
        );
      }
    }
    return Duration(seconds: parsePart(duration));
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _currentSpeed, // Use local cache
      queueIndex: _player.currentIndex,
    );
  }

  Future<void> _applySpeedForEpisode(Episode episode) async {
    final savedSpeed =
        await _storageService.getPodcastSpeed(episode.podcastFeedUrl);
    if (savedSpeed != null) {
      print(
          '[SpeedLog] AudioHandler: Found saved speed $savedSpeed for ${episode.podcastTitle}, applying.');
      await setSpeed(savedSpeed);
    } else {
      // Reset to normal speed if no preference for this podcast
      print(
          '[SpeedLog] AudioHandler: No saved speed for ${episode.podcastTitle}, resetting to 1.0x.');
      await setSpeed(1.0);
    }
  }
}
