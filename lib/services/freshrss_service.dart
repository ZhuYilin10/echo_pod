import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/models/podcast.dart';
import '../core/models/episode.dart';

class FreshRssService {
  final Dio _dio = Dio();
  
  String? _baseUrl;
  String? _username;
  String? _password;
  String? _authToken;

  void configure(String baseUrl, String username, String password) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    _username = username;
    _password = password;
  }

  Future<bool> login() async {
    if (_baseUrl == null || _username == null || _password == null) return false;

    try {
      final response = await _dio.post(
        '${_baseUrl}api/greader.php/accounts/ClientLogin',
        queryParameters: {
          'Email': _username,
          'Passwd': _password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data.toString();
        final authMatch = RegExp(r'Auth=(.*)').firstMatch(data);
        if (authMatch != null) {
          _authToken = authMatch.group(1);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('FreshRSS Login Error: $e');
      return false;
    }
  }

  Future<List<Podcast>> fetchSubscriptions() async {
    if (_authToken == null) await login();
    if (_authToken == null) return [];

    try {
      final response = await _dio.get(
        '${_baseUrl}api/greader.php/reader/api/0/subscription/list',
        queryParameters: {'output': 'json'},
        options: Options(headers: {'Authorization': 'GoogleLogin auth=$_authToken'}),
      );

      if (response.statusCode == 200) {
        final List subscriptions = response.data['subscriptions'] ?? [];
        return subscriptions.map((s) {
          return Podcast(
            title: s['title'] ?? 'Unknown',
            feedUrl: s['id']?.replaceFirst('feed/', '') ?? '',
            imageUrl: null, // GReader API doesn't usually provide high-res images
            artist: null,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('FreshRSS Fetch Subscriptions Error: $e');
      return [];
    }
  }

  Future<List<Episode>> fetchRecentEpisodes({int limit = 50}) async {
    if (_authToken == null) await login();
    if (_authToken == null) return [];

    try {
      final response = await _dio.get(
        '${_baseUrl}api/greader.php/reader/api/0/stream/contents/reading-list',
        queryParameters: {
          'output': 'json',
          'n': limit,
        },
        options: Options(headers: {'Authorization': 'GoogleLogin auth=$_authToken'}),
      );

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((item) {
          final enclosure = (item['enclosure'] as List?)?.firstOrNull;
          
          return Episode(
            guid: item['id'] ?? '',
            title: item['title'] ?? 'No Title',
            description: item['summary']?['content'] ?? item['content']?['content'],
            pubDate: DateTime.fromMillisecondsSinceEpoch((item['published'] ?? 0) * 1000),
            audioUrl: enclosure?['href'],
            imageUrl: null,
            podcastTitle: item['origin']?['title'] ?? '',
            podcastFeedUrl: item['origin']?['streamId']?.replaceFirst('feed/', '') ?? '',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('FreshRSS Fetch Episodes Error: $e');
      return [];
    }
  }
}
