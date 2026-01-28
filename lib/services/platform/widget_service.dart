import 'package:flutter/services.dart';

class WidgetService {
  static const _channel = MethodChannel('com.echopod.ai/widget');

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
    } on PlatformException catch (_) {}
  }
}
