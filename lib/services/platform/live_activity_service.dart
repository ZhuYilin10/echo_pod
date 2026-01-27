import 'package:flutter/services.dart';

class LiveActivityService {
  static const MethodChannel _channel = MethodChannel('com.echopod.live_activity');

  Future<void> startLiveActivity({
    required String podcastTitle,
    required String episodeTitle,
    required String imageUrl,
    required double progress,
    required bool isPlaying,
  }) async {
    try {
      await _channel.invokeMethod('startLiveActivity', {
        'podcastTitle': podcastTitle,
        'episodeTitle': episodeTitle,
        'imageUrl': imageUrl,
        'progress': progress,
        'isPlaying': isPlaying,
      });
    } on PlatformException catch (e) {
      print("Failed to start Live Activity: '${e.message}'.");
    }
  }

  Future<void> updateLiveActivity({
    required double progress,
    required bool isPlaying,
  }) async {
    try {
      await _channel.invokeMethod('updateLiveActivity', {
        'progress': progress,
        'isPlaying': isPlaying,
      });
    } on PlatformException catch (e) {
      print("Failed to update Live Activity: '${e.message}'.");
    }
  }

  Future<void> stopLiveActivity() async {
    try {
      await _channel.invokeMethod('stopLiveActivity');
    } on PlatformException catch (e) {
      print("Failed to stop Live Activity: '${e.message}'.");
    }
  }
}
