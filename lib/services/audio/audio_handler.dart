import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/models/episode.dart';
import '../platform/live_activity_service.dart';
import '../storage/storage_service.dart';

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

  EchoPodAudioHandler(this._liveActivityService, this._storageService) {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _player.setAudioSource(_playlist);

    // Sync media item based on current index
    _player.currentIndexStream.listen((index) {
      if (index != null && index < queue.value.length) {
        mediaItem.add(queue.value[index]);
      }
    });

    // Listen to position changes to update Live Activity and track saved time
    DateTime? lastPositionUpdate;
    Duration? lastPosition;

    _player.positionStream.listen((position) {
      _updateLiveActivity(position);

      if (_isSkipSilenceEnabled &&
          _player.playing &&
          lastPosition != null &&
          lastPositionUpdate != null) {
        final now = DateTime.now();
        final wallElapsedMs = now.difference(lastPositionUpdate!).inMilliseconds;
        final audioElapsedMs = (position - lastPosition!).inMilliseconds;
        final expectedElapsedMs = (wallElapsedMs * _player.speed).round();

        // If audio jumped forward more than expected (allowing for some jitter)
        // threshold 300ms jitter is safe for 1 second interval
        if (audioElapsedMs > expectedElapsedMs + 300) {
          final savedMs = audioElapsedMs - expectedElapsedMs;
          if (savedMs > 0 && savedMs < 10000) { // Limit to 10s jump to avoid seek confusion
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
      if (!playing) {
        lastPosition = null;
        lastPositionUpdate = null;
      }
      _updateLiveActivity(_player.position);
      if (playing && _currentEpisode != null) {}
    });

    _init();
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
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _saveCurrentPosition();
    _stopSaveTimer();
    await _player.stop();
    if (_liveActivityActive) {
      await _liveActivityService.stopLiveActivity();
      _liveActivityActive = false;
    }
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  bool get isSkipSilenceEnabled => _isSkipSilenceEnabled;

  Future<void> setSkipSilence(bool enabled) async {
    _isSkipSilenceEnabled = enabled;
    await _storageService.saveSkipSilenceEnabled(enabled);
    await _player.setSkipSilenceEnabled(enabled);
  }

  Stream<bool> get skipSilenceStream => _player.skipSilenceEnabledStream;

  Stream<Duration> get totalTimeSavedStream => _timeSavedController.stream;

  Stream<Duration?> get sleepTimerStream => _sleepTimerController.stream;

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

  Future<void> playEpisode(Episode episode, {bool autoPlay = true}) async {
    print(
        'AudioHandler: playEpisode called for ${episode.title}, url: ${episode.audioUrl}');
    if (episode.audioUrl == null) {
      print('AudioHandler: playEpisode aborted - audioUrl is null');
      return;
    }

    try {
      // Save current position before switching
      await _saveCurrentPosition();
      _currentEpisode = episode;

      final item = MediaItem(
        id: episode.guid, // Use guid as ID for consistency and Hero tags
        album: episode.podcastTitle,
        title: episode.title,
        artUri: episode.imageUrl != null ? Uri.parse(episode.imageUrl!) : null,
        duration: _parseDuration(episode.duration),
        extras: episode.toJson(),
      );

      // LIFO Logic:
      // 1. Check if episode is already in queue
      final currentQueue = queue.value;
      final existingIndex =
          currentQueue.indexWhere((i) => i.id == episode.guid);

      print('AudioHandler: Queue length before: ${queue.value.length}');
      print('AudioHandler: Playlist length before: ${_playlist.length}');

      // Stop before modifying playlist to avoid index confusion
      await _player.stop();

      if (existingIndex == 0) {
        print('AudioHandler: Episode already at top. Playing from 0.');
        // Already at top, just play
        await _player.seek(Duration.zero, index: 0);
      } else {
        if (existingIndex > 0) {
          print(
              'AudioHandler: Moving existing episode from index $existingIndex to top.');
          // Move to top
          await removeQueueItemAt(existingIndex);
        } else {
          print('AudioHandler: Inserting new episode at top.');
        }

        // Insert at top
        // Note: insert(0) shifts current items down.
        // Index 0 becomes the new item.
        final source = await _buildAudioSource(item);
        print('AudioHandler: Inserting source $source at index 0');
        await _playlist.insert(0, source);
        final newQueue = List<MediaItem>.from(queue.value)..insert(0, item);
        queue.add(newQueue);

        print('AudioHandler: Queue length after: ${queue.value.length}');
        print('AudioHandler: Playlist length after: ${_playlist.length}');

        // Play the new top item
        print('AudioHandler: Seeking to index 0 (new item).');
        await _player.seek(Duration.zero, index: 0);
      }

      // Explicitly update mediaItem to ensure UI reflects current item immediately
      mediaItem.add(item);

      // Persist to history immediately so if app restarts, this episode is top
      await _storageService.addToHistory(episode);

      // Restore saved position
      final savedPosition = await _storageService.getPosition(episode.guid);
      if (savedPosition > Duration.zero) {
        await _player.seek(savedPosition);
      }

      if (autoPlay) {
        print('AudioHandler: Starting playback...');
        await play();

        // Start Live Activity only if playing
        await _liveActivityService.startLiveActivity(
          podcastTitle: episode.podcastTitle,
          episodeTitle: episode.title,
          imageUrl: episode.imageUrl ?? "",
          progress: 0.0,
          isPlaying: true,
        );
        _liveActivityActive = true;

        // Start saving position timer
        _startSaveTimer();
      }
    } catch (e, stack) {
      print('AudioHandler: Error in playEpisode: $e');
      print(stack);
      // Ensure we don't end up in a stuck state
      if (mediaItem.value?.id == episode.guid) {
        mediaItem.add(null);
      }
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
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
