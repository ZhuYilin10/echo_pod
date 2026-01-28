import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
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

  EchoPodAudioHandler(this._liveActivityService, this._storageService) {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _player.setAudioSource(_playlist);
    
    // Sync media item based on current index
    _player.currentIndexStream.listen((index) {
      if (index != null && index < queue.value.length) {
        mediaItem.add(queue.value[index]);
      }
    });

    // Listen to position changes to update Live Activity
    _player.positionStream.listen((position) {
      _updateLiveActivity(position);
    });

    // Listen to playing state changes
    _player.playingStream.listen((playing) {
      _updateLiveActivity(_player.position);
      if (playing && _currentEpisode != null) {
        _storageService.addToHistory(_currentEpisode!);
        _startSaveTimer();
      } else {
        _stopSaveTimer();
        _saveCurrentPosition();
      }
    });
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
    if (_currentEpisode != null) {
      await _storageService.savePosition(_currentEpisode!.guid, _player.position);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final source = await _buildAudioSource(mediaItem);
    await _playlist.add(source);
    final newQueue = List<MediaItem>.from(queue.value)..add(mediaItem);
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
    final fileName = audioUrl.split('/').last.split('?').first;
    final localFile = File('${directory.path}/downloads/$fileName');
    
    if (localFile.existsSync()) {
      return AudioSource.file(localFile.path, tag: item);
    } else {
      return LockCachingAudioSource(Uri.parse(audioUrl), tag: item);
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

  Future<void> setSkipSilence(bool enabled) async {
    // Skipping silence logic would go here
  }

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
    if (episode.audioUrl == null) return;
    
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

    // Clear current queue and play this one immediately
    await _playlist.clear();
    queue.add([item]);
    mediaItem.add(item); // Explicitly update mediaItem
    await _playlist.add(await _buildAudioSource(item));
    
    // Restore saved position
    final savedPosition = await _storageService.getPosition(episode.guid);
    if (savedPosition > Duration.zero) {
      await _player.seek(savedPosition);
    }
    
    if (autoPlay) {
      play();
      
      // Start Live Activity only if playing
      await _liveActivityService.startLiveActivity(
        podcastTitle: episode.podcastTitle,
        episodeTitle: episode.title,
        imageUrl: episode.imageUrl ?? "",
        progress: 0.0,
        isPlaying: true,
      );
      _liveActivityActive = true;
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
