import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/podcast.dart';

class StorageService {
  static const String _subKey = 'subscriptions';

  Future<void> subscribe(Podcast podcast) async {
    final prefs = await SharedPreferences.getInstance();
    final subs = await getSubscriptions();
    if (!subs.any((p) => p.feedUrl == podcast.feedUrl)) {
      subs.add(podcast);
      await prefs.setString(_subKey, jsonEncode(subs.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> unsubscribe(String feedUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final subs = await getSubscriptions();
    subs.removeWhere((p) => p.feedUrl == feedUrl);
    await prefs.setString(_subKey, jsonEncode(subs.map((e) => e.toJson()).toList()));
  }

  Future<bool> isSubscribed(String feedUrl) async {
    final subs = await getSubscriptions();
    return subs.any((p) => p.feedUrl == feedUrl);
  }

  Future<List<Podcast>> getSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_subKey);
    if (raw == null) return [];
    try {
      final List list = jsonDecode(raw);
      return list.map((e) => Podcast.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String> exportToOpml() async {
    final subs = await getSubscriptions();
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<opml version="1.0">');
    buffer.writeln('  <head>');
    buffer.writeln('    <title>EchoPod Subscriptions</title>');
    buffer.writeln('  </head>');
    buffer.writeln('  <body>');
    for (final podcast in subs) {
      final title = _escapeXml(podcast.title);
      final xmlUrl = _escapeXml(podcast.feedUrl);
      buffer.writeln('    <outline text="$title" type="rss" xmlUrl="$xmlUrl" />');
    }
    buffer.writeln('  </body>');
    buffer.writeln('</opml>');
    return buffer.toString();
  }

  String _escapeXml(String str) {
    return str
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
