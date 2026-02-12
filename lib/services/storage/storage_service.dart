import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/episode.dart';
import '../../core/models/podcast.dart';
import '../../core/theme/theme_config.dart';

class StorageService {
  static const String _subKey = 'subscriptions';
  static const String _downloadKey = 'downloaded_episodes';
  static const String _historyKey = 'play_history';
  static const String _positionKey = 'playback_positions';
  static const String _timeSavedKey = 'total_time_saved';
  static const String _skipSilenceKey = 'skip_silence_enabled';
  static const String _podcastSpeedsKey = 'podcast_speeds';
  static const String _themeKey = 'app_theme_config';
  static const String _freshrssUrlKey = 'freshrss_url';
  static const String _freshrssUserKey = 'freshrss_user';
  static const String _freshrssPassKey = 'freshrss_pass';

  Future<void> saveFreshRssConfig(String url, String user, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_freshrssUrlKey, url);
    await prefs.setString(_freshrssUserKey, user);
    await prefs.setString(_freshrssPassKey, pass);
  }

  Future<Map<String, String?>> getFreshRssConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'url': prefs.getString(_freshrssUrlKey),
      'user': prefs.getString(_freshrssUserKey),
      'pass': prefs.getString(_freshrssPassKey),
    };
  }

  Future<void> savePodcastSpeed(String feedUrl, double speed) async {
    print('[SpeedLog] StorageService: Saving speed $speed for feed $feedUrl');
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_podcastSpeedsKey);
    Map<String, double> speeds = {};
    if (raw != null) {
      try {
        speeds = Map<String, double>.from(jsonDecode(raw));
      } catch (_) {}
    }
    speeds[feedUrl] = speed;
    await prefs.setString(_podcastSpeedsKey, jsonEncode(speeds));
  }

  Future<void> removePodcastSpeed(String feedUrl) async {
    print('[SpeedLog] StorageService: Removing saved speed for feed $feedUrl');
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_podcastSpeedsKey);
    Map<String, double> speeds = {};
    if (raw != null) {
      try {
        speeds = Map<String, double>.from(jsonDecode(raw));
      } catch (_) {}
    }
    speeds.remove(feedUrl);
    await prefs.setString(_podcastSpeedsKey, jsonEncode(speeds));
  }

  Future<double?> getPodcastSpeed(String feedUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_podcastSpeedsKey);
    if (raw == null) return null;
    try {
      final Map<String, dynamic> speeds = jsonDecode(raw);
      return speeds[feedUrl]?.toDouble();
    } catch (_) {
      return null;
    }
  }

  Future<void> subscribe(Podcast podcast) async {
    final prefs = await SharedPreferences.getInstance();
    final subs = await getSubscriptions();
    if (!subs.any((p) => p.feedUrl == podcast.feedUrl)) {
      subs.add(podcast);
      await prefs.setString(
          _subKey, jsonEncode(subs.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> unsubscribe(String feedUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final subs = await getSubscriptions();
    subs.removeWhere((p) => p.feedUrl == feedUrl);
    await prefs.setString(
        _subKey, jsonEncode(subs.map((e) => e.toJson()).toList()));
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
      await prefs.setString(
          _downloadKey, jsonEncode(downloads.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> removeDownload(String guid) async {
    final prefs = await SharedPreferences.getInstance();
    final downloads = await getDownloadedEpisodes();
    downloads.removeWhere((e) => e.guid == guid);
    await prefs.setString(
        _downloadKey, jsonEncode(downloads.map((e) => e.toJson()).toList()));
  }

  Future<List<Episode>> getDownloadedEpisodes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_downloadKey);
    if (raw == null) return [];
    try {
      final List list = jsonDecode(raw);
      // Optional: Filter to only return episodes where the file actually exists
      // But for UI speed, we'll return all and let UI handle broken links or cleanup
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
    // Keep last 300 items
    if (history.length > 300) history.removeLast();
    await prefs.setString(
        _historyKey, jsonEncode(history.map((e) => e.toJson()).toList()));
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

  Future<void> addTimeSaved(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final currentMs = prefs.getInt(_timeSavedKey) ?? 0;
    await prefs.setInt(_timeSavedKey, currentMs + duration.inMilliseconds);
  }

  Future<Duration> getTotalTimeSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_timeSavedKey) ?? 0;
    return Duration(milliseconds: ms);
  }

  Future<void> saveSkipSilenceEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_skipSilenceKey, enabled);
  }

  Future<bool> getSkipSilenceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_skipSilenceKey) ?? false;
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
      buffer
          .writeln('    <outline text="$title" type="rss" xmlUrl="$xmlUrl" />');
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

  // 主题配置持久化
  Future<void> saveTheme(AppThemeConfig theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, jsonEncode(theme.toJson()));
  }

  Future<AppThemeConfig?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_themeKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppThemeConfig.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  // --- File-based Cache Implementation ---

  Future<File> _getCacheFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    // 使用 hashCode 生成简单的文件名
    final filename = 'feed_cache_${url.hashCode}.json';
    return File('${directory.path}/$filename');
  }

  Future<void> saveFeedCache(String url, List<Episode> episodes) async {
    try {
      final file = await _getCacheFile(url);
      final jsonStr = jsonEncode(episodes.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonStr);
    } catch (e) {
      print('Error saving cache for $url: $e');
    }
  }

  Future<List<Episode>?> getFeedCache(String url) async {
    try {
      final file = await _getCacheFile(url);
      if (await file.exists()) {
        final jsonStr = await file.readAsString();
        final List list = jsonDecode(jsonStr);
        return list.map((e) => Episode.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error reading cache for $url: $e');
    }
    return null;
  }

  Future<DateTime?> getFeedCacheTime(String url) async {
    try {
      final file = await _getCacheFile(url);
      if (await file.exists()) {
        return await file.lastModified();
      }
    } catch (e) {
      print('Error getting cache time for $url: $e');
    }
    return null;
  }
}
