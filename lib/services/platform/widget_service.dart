import 'package:flutter/services.dart';

class WidgetService {
  static const _channel = MethodChannel('com.echopod.ai/widget');

  /// Updates the iOS Home Screen Widget with a new golden sentence.
  /// 
  /// [quote]: The AI extracted golden sentence.
  /// [author]: The podcast or episode title.
  /// [imageUrl]: The artwork URL.
  Future<void> updateQuoteWidget({
    required String quote,
    required String author,
    required String imageUrl,
  }) async {
    try {
      await _channel.invokeMethod('updateQuote', {
        'quote': quote,
        'author': author,
        'imageUrl': imageUrl,
      });
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'.");
    }
  }
}
