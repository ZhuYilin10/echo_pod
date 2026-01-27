import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/episode.dart';
import '../../core/models/podcast.dart';

class StorageService {
  static const String _subKey = 'subscriptions';
  static const String _downloadKey = 'downloaded_episodes';
  static const String _historyKey = 'play_history';
  static const String _positionKey = 'playback_positions';

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

  Future<void> saveDownload(Episode episode) async {
    final prefs = await SharedPreferences.getInstance();
    final downloads = await getDownloadedEpisodes();
    if (!downloads.any((e) => e.guid == episode.guid)) {
      downloads.add(episode);
      await prefs.setString(_downloadKey, jsonEncode(downloads.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> removeDownload(String guid) async {
    final prefs = await SharedPreferences.getInstance();
    final downloads = await getDownloadedEpisodes();
    downloads.removeWhere((e) => e.guid == guid);
    await prefs.setString(_downloadKey, jsonEncode(downloads.map((e) => e.toJson()).toList()));
  }

  Future<List<Episode>> getDownloadedEpisodes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_downloadKey);
    if (raw == null) return [];
    try {
      final List list = jsonDecode(raw);
      return list.map((e) => Episode.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addToHistory(Episode episode) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getPlayHistory();
    // Remove if already exists to move to top
    history.removeWhere((e) => e.guid == episode.guid);
    history.insert(0, episode);
    // Keep last 100 items
    if (history.length > 100) history.removeLast();
    await prefs.setString(_historyKey, jsonEncode(history.map((e) => e.toJson()).toList()));
  }

  Future<List<Episode>> getPlayHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    try {
      final List list = jsonDecode(raw);
      return list.map((e) => Episode.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> savePosition(String guid, Duration position) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_positionKey);
    Map<String, int> positions = {};
    if (raw != null) {
      try {
        positions = Map<String, int>.from(jsonDecode(raw));
      } catch (_) {}
    }
    positions[guid] = position.inMilliseconds;
    // Limit storage to 200 episodes
    if (positions.length > 200) {
      final keysToRemove = positions.keys.take(positions.length - 200);
      for (var k in keysToRemove) {
        positions.remove(k);
      }
    }
    await prefs.setString(_positionKey, jsonEncode(positions));
  }

  Future<Duration> getPosition(String guid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_positionKey);
    if (raw == null) return Duration.zero;
    try {
      final Map<String, dynamic> positions = jsonDecode(raw);
      final ms = positions[guid];
      if (ms != null) return Duration(milliseconds: ms);
    } catch (_) {}
    return Duration.zero;
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
