import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BilibiliVideoInfo {
  final String title;
  final String? coverUrl;
  final String? videoUrl;
  final String? description;
  final String? author;
  final String? authorAvatar;

  BilibiliVideoInfo({
    required this.title,
    this.coverUrl,
    required this.videoUrl,
    this.description,
    this.author,
    this.authorAvatar,
  });
}

class BilibiliParserService {
  static const String _apiUrl = 'https://api.mir6.com/api/bzjiexi';

  Future<String> resolveShortUrl(String url) async {
    if (!url.contains('b23.tv')) return url;

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url))..followRedirects = false;
      final response = await client.send(request);
      
      final location = response.headers['location'];
      if (location != null) {
        return location.split('?').first; // Strip tracking params
      }
    } catch (e) {
      debugPrint('Error resolving short URL: $e');
    }
    return url;
  }

  Future<BilibiliVideoInfo> parse(String url) async {
    try {
      final resolvedUrl = await resolveShortUrl(url);
      final uri = Uri.parse(_apiUrl).replace(queryParameters: {
        'url': resolvedUrl,
        'type': 'json',
      });

      debugPrint('BilibiliParser: Fetching $uri');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 200) {
          final videoData = data['data'][0]; // Usually the first item

          return BilibiliVideoInfo(
            title: data['title'] ?? 'Unknown Title',
            coverUrl: data['imgurl'],
            videoUrl: videoData['video_url'],
            description: data['desc'],
            author: data['user']?['name'],
            authorAvatar: data['user']?['user_img'],
          );
        } else {
          throw Exception('Bilibili API Error: ${data['msg']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('BilibiliParser Error: $e');
      rethrow;
    }
  }
}
