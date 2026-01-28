import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/models/podcast.dart';

class DiscoveryService {
  final Dio _dio = Dio();

  static const String _hotPodcastsUrl =
      'https://raw.githubusercontent.com/eddiehe99/xyzrank/main/full.json';

  Future<List<Podcast>> fetchDailyRecommendations() async {
    try {
      final response = await _dio.get(_hotPodcastsUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.data);
        final List<dynamic> data = body['data']['podcasts'];

        return data
            .take(100)
            .map((json) {
              String? feedUrl;
              if (json['links'] != null) {
                final links = json['links'] as List;
                final rssLink = links.firstWhere((l) => l['name'] == 'rss',
                    orElse: () => null);
                feedUrl = rssLink?['url'];
              }

              if (feedUrl == null) return null;

              return Podcast(
                title: json['name'] ?? '未知播客',
                artist: json['authorsText'] ?? '未知主播',
                imageUrl: json['logoURL'],
                feedUrl: feedUrl,
                description: json['description'],
              );
            })
            .whereType<Podcast>()
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Podcast>> fetchByGenre(String genreId) async {
    try {
      // Step 1: Fetch Top 50 IDs from RSS Feed
      final rssUrl =
          'https://itunes.apple.com/cn/rss/toppodcasts/limit=50/genre=$genreId/json';
      final rssResponse = await _dio.get(rssUrl);

      if (rssResponse.statusCode != 200) return [];

      final Map<String, dynamic> rssBody = json.decode(rssResponse.data);
      final List<dynamic> entries = rssBody['feed']['entry'] ?? [];

      final ids = entries.map((e) {
        return e['id']['attributes']['im:id'] as String;
      }).toList();

      if (ids.isEmpty) return [];

      // Step 2: Batch fetch details using Lookup API
      final lookupUrl = 'https://itunes.apple.com/cn/lookup';
      final lookupResponse = await _dio.get(lookupUrl, queryParameters: {
        'id': ids.join(','),
      });

      if (lookupResponse.statusCode != 200) return [];

      final lookupBody = json.decode(lookupResponse.data);
      final List<dynamic> results = lookupBody['results'] ?? [];

      return results
          .map((item) {
            return Podcast(
              title: item['collectionName'] ?? 'Unknown',
              artist: item['artistName'] ?? 'Unknown',
              feedUrl: item['feedUrl'] ?? '',
              imageUrl: item['artworkUrl600'] ?? item['artworkUrl100'],
              description:
                  '', // Lookup API doesn't return full description usually
            );
          })
          .where((p) => p.feedUrl.isNotEmpty)
          .toList();
    } catch (_) {}
    return [];
  }
}
