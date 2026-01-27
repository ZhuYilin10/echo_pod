import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/models/podcast.dart';

class DiscoveryService {
  final Dio _dio = Dio();
  
  // Using xyzrank data source from GitHub
  static const String _hotPodcastsUrl = 'https://raw.githubusercontent.com/eddiehe99/xyzrank/main/full.json';

  Future<List<Podcast>> fetchDailyRecommendations() async {
    try {
      final response = await _dio.get(_hotPodcastsUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.data);
        final List<dynamic> data = body['data']['podcasts'];
        
        // Take top 30 as recommendations
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
          );
        }).whereType<Podcast>().toList();
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
    return [];
  }
}
