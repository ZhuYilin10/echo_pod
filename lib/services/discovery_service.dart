import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/models/podcast.dart';

class DiscoveryService {
  final Dio _dio = Dio();
  
  static const String _hotPodcastsUrl = 'https://raw.githubusercontent.com/eddiehe99/xyzrank/main/full.json';

  Future<List<Podcast>> fetchDailyRecommendations() async {
    try {
      final response = await _dio.get(_hotPodcastsUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.data);
        final List<dynamic> data = body['data']['podcasts'];
        
        return data.take(30).map((json) {
          String? feedUrl;
          if (json['links'] != null) {
             final links = json['links'] as List;
             final rssLink = links.firstWhere((l) => l['name'] == 'rss', orElse: () => null);
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
        }).whereType<Podcast>().toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Podcast>> fetchByGenre(String genreId) async {
    try {
      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'term': 'podcast',
          'media': 'podcast',
          'genreId': genreId,
          'country': 'CN',
          'limit': 50,
        },
      );
      
      final results = response.data['results'] as List;
      return results.map((item) {
        return Podcast(
          title: item['collectionName'] ?? 'Unknown',
          artist: item['artistName'],
          feedUrl: item['feedUrl'],
          imageUrl: item['artworkUrl600'] ?? item['artworkUrl100'],
          description: '',
        );
      }).toList();
    } catch (_) {}
    return [];
  }
}
