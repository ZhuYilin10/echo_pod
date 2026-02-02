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
  // Bilibili Official API - DASH format with codec selection
  static const String _playurlApi = 'https://api.bilibili.com/x/player/playurl';
  static const String _videoInfoApi =
      'https://api.bilibili.com/x/web-interface/view';

  // Legacy fallback
  static const String _fallbackApiUrl = 'https://api.mir6.com/api/bzjiexi';

  static const Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
    'Referer': 'https://www.bilibili.com/',
  };

  Future<String> resolveShortUrl(String url) async {
    if (!url.contains('b23.tv')) return url;

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url))
        ..followRedirects = false
        ..headers.addAll(_headers);
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

  /// Extract BV ID from Bilibili URL
  String? _extractBvid(String url) {
    // Match patterns like BV1V142187ur
    final bvMatch = RegExp(r'BV[a-zA-Z0-9]+').firstMatch(url);
    return bvMatch?.group(0);
  }

  Future<BilibiliVideoInfo> parse(String url) async {
    try {
      final resolvedUrl = await resolveShortUrl(url);
      final bvid = _extractBvid(resolvedUrl);

      if (bvid == null) {
        throw Exception('无法提取视频 BV 号');
      }

      debugPrint('BilibiliParser: Parsing BVID: $bvid');

      // 1. Get video info (cid, title, cover, author)
      final infoUri = Uri.parse(_videoInfoApi).replace(queryParameters: {
        'bvid': bvid,
      });

      final infoResponse = await http.get(infoUri, headers: _headers);
      if (infoResponse.statusCode != 200) {
        throw Exception('获取视频信息失败: ${infoResponse.statusCode}');
      }

      final infoData = json.decode(infoResponse.body);
      if (infoData['code'] != 0) {
        throw Exception('API错误: ${infoData['message']}');
      }

      final videoInfo = infoData['data'];
      final cid = videoInfo['cid'];
      final title = videoInfo['title'] ?? 'Unknown Title';
      final coverUrl = videoInfo['pic'];
      final description = videoInfo['desc'];
      final author = videoInfo['owner']?['name'];
      final authorAvatar = videoInfo['owner']?['face'];

      debugPrint('BilibiliParser: Got CID: $cid, Title: $title');

      // 2. Get playurl with MP4 format (fnval=1) and LOW quality (qn=16 = 360P)
      // qn=16 (360P) guarantees AVC codec (-1-16.mp4 format)
      // Higher qualities like 720P/1080P often only have HEVC which causes green screen on iOS
      final playurlUri = Uri.parse(_playurlApi).replace(queryParameters: {
        'bvid': bvid,
        'cid': cid.toString(),
        'qn': '16', // 360P - guarantees AVC codec on most videos
        'fnval': '1', // MP4 format (not DASH)
        'fourk': '0',
      });

      debugPrint('BilibiliParser: Fetching playurl (360P AVC): $playurlUri');
      final playResponse = await http.get(playurlUri, headers: _headers);

      if (playResponse.statusCode != 200) {
        throw Exception('获取播放地址失败: ${playResponse.statusCode}');
      }

      final playData = json.decode(playResponse.body);
      if (playData['code'] != 0) {
        throw Exception('播放API错误: ${playData['message']}');
      }

      // Extract video URL from durl array
      final durl = playData['data']?['durl'];
      if (durl == null || (durl as List).isEmpty) {
        throw Exception('未找到视频流');
      }

      final videoUrl = durl[0]['url'] as String;
      final codecId = playData['data']?['video_codecid'] ?? 'unknown';
      debugPrint('BilibiliParser: Got video URL (codecid=$codecId): $videoUrl');

      return BilibiliVideoInfo(
        title: title,
        coverUrl: coverUrl,
        videoUrl: videoUrl,
        description: description,
        author: author,
        authorAvatar: authorAvatar,
      );
    } catch (e) {
      debugPrint('BilibiliParser Official API Error: $e');

      // Fallback to legacy parser
      debugPrint('BilibiliParser: Falling back to legacy API...');
      return _parseLegacy(url);
    }
  }

  /// Parse using durl format (non-DASH)
  BilibiliVideoInfo _parseWithDurl(
    Map<String, dynamic> playData,
    String title,
    String? coverUrl,
    String? description,
    String? author,
    String? authorAvatar,
  ) {
    final durl = playData['data']?['durl'];
    if (durl == null || (durl as List).isEmpty) {
      throw Exception('未找到视频流');
    }

    final videoUrl = durl[0]['url'] as String;
    debugPrint('BilibiliParser: Got video URL (durl): $videoUrl');

    return BilibiliVideoInfo(
      title: title,
      coverUrl: coverUrl,
      videoUrl: videoUrl,
      description: description,
      author: author,
      authorAvatar: authorAvatar,
    );
  }

  /// Legacy parser fallback (mir6 API)
  Future<BilibiliVideoInfo> _parseLegacy(String url) async {
    final resolvedUrl = await resolveShortUrl(url);

    final uri = Uri.parse(_fallbackApiUrl).replace(queryParameters: {
      'url': resolvedUrl,
      'type': 'json',
    });

    debugPrint('BilibiliParser: Fetching legacy $uri');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['code'] == 200 &&
          data['data'] != null &&
          (data['data'] as List).isNotEmpty) {
        final videoData = data['data'][0];

        return BilibiliVideoInfo(
          title: data['title'] ?? 'Unknown Title',
          coverUrl: data['imgurl'],
          videoUrl: videoData['video_url'],
          description: data['desc'],
          author: data['user']?['name'],
          authorAvatar: data['user']?['user_img'],
        );
      } else {
        throw Exception('未找到有效的视频流地址');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }
}
