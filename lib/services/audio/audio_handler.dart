import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/models/episode.dart';
import '../platform/live_activity_service.dart';

class EchoPodAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final LiveActivityService _liveActivityService;
  bool _liveActivityActive = false;

  EchoPodAudioHandler(this._liveActivityService) {
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
    });
  }

  @override
  Future<void> addQueueItem(MediaItem item) async {
    final source = await _buildAudioSource(item);
    await _playlist.add(source);
    final newQueue = List<MediaItem>.from(queue.value)..add(item);
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
    final directory = await getApplicationDocumentsDirectory();
    final fileName = item.id.split('/').last.split('?').first;
    final localFile = File('${directory.path}/downloads/$fileName');
    
    if (localFile.existsSync()) {
      return AudioSource.file(localFile.path, tag: item);
    } else {
      return LockCachingAudioSource(Uri.parse(item.id), tag: item);
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);



  Future<void> playEpisode(Episode episode) async {
    if (episode.audioUrl == null) return;

    final item = MediaItem(
      id: episode.audioUrl!,
      album: episode.podcastTitle,
      title: episode.title,
      artUri: episode.imageUrl != null ? Uri.parse(episode.imageUrl!) : null,
      duration: _parseDuration(episode.duration),
    );

    // Clear current queue and play this one immediately
    await _playlist.clear();
    queue.add([item]);
    mediaItem.add(item); // Explicitly update mediaItem
    await _playlist.add(await _buildAudioSource(item));
    
    play();
    
    // Start Live Activity
    await _liveActivityService.startLiveActivity(
      podcastTitle: episode.podcastTitle ?? "EchoPod",
      episodeTitle: episode.title ?? "Episode",
      imageUrl: episode.imageUrl ?? "",
      progress: 0.0,
      isPlaying: true,
    );
    _liveActivityActive = true;
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
