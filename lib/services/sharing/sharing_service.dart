import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

/// iOS 分享导入工具：
/// 1) 读取 App Group 中 pending 的分享文件元数据
/// 2) 清理已处理的 pending 标记
/// 3) 读取并解析 OPML 内容
class SharingService {
  static const MethodChannel platform = MethodChannel('com.echopod/share');

  static Future<Map<dynamic, dynamic>?> checkPendingSharedFile() async {
    return platform.invokeMethod<Map<dynamic, dynamic>>('checkSharedFile');
  }

  static Future<void> clearPendingSharedFile() async {
    await platform.invokeMethod('clearSharedFile');
  }

  static Future<String?> readOpmlFile(String filePath) async {
    try {
      if (filePath.isEmpty) return null;

      final file = File(filePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;

      try {
        return utf8.decode(bytes);
      } on FormatException {
        // Fallback for non-UTF8 OPML files exported by some legacy apps.
        return latin1.decode(bytes);
      }
    } catch (_) {
      return null;
    }
  }

  static List<OpmlPodcastInfo> parseOpmlPodcasts(String content) {
    final podcasts = <OpmlPodcastInfo>[];
    final seenFeedUrls = <String>{};
    final document = parse(content.replaceFirst('\uFEFF', ''));
    final outlines = document.querySelectorAll('outline');

    for (final outline in outlines) {
      final rawXmlUrl = _getAttributeByNames(
        outline,
        const ['xmlUrl', 'xmlurl'],
      );
      if (rawXmlUrl == null) continue;

      final normalizedUrl = normalizeFeedUrl(_decodeXmlEntities(rawXmlUrl));
      if (normalizedUrl.isEmpty || !seenFeedUrls.add(normalizedUrl)) {
        continue;
      }

      final rawTitle = _getAttributeByNames(
        outline,
        const ['text', 'title'],
      );
      final decodedTitle =
          rawTitle == null ? '' : _decodeXmlEntities(rawTitle).trim();

      podcasts.add(
        OpmlPodcastInfo(
          title: decodedTitle.isEmpty ? '未知播客' : decodedTitle,
          feedUrl: normalizedUrl,
          selected: true,
        ),
      );
    }

    return podcasts;
  }

  static List<String> dedupeFeedUrls(Iterable<String> urls) {
    final seen = <String>{};
    final deduped = <String>[];
    for (final url in urls) {
      final normalized = normalizeFeedUrl(url);
      if (normalized.isEmpty) continue;
      if (seen.add(normalized)) {
        deduped.add(normalized);
      }
    }
    return deduped;
  }

  static String normalizeFeedUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return trimmed;
    }

    final loweredScheme = uri.scheme.toLowerCase();
    final loweredHost = uri.host.toLowerCase();
    int? normalizedPort = uri.hasPort ? uri.port : null;
    if ((loweredScheme == 'http' && normalizedPort == 80) ||
        (loweredScheme == 'https' && normalizedPort == 443)) {
      normalizedPort = null;
    }

    return uri
        .replace(
          scheme: loweredScheme,
          host: loweredHost,
          port: normalizedPort,
        )
        .toString();
  }

  static String? _getAttributeByNames(dom.Element element, List<String> names) {
    for (final name in names) {
      final value = element.attributes[name];
      if (value != null && value.isNotEmpty) return value;
    }

    final loweredNames = names.map((e) => e.toLowerCase()).toSet();
    for (final entry in element.attributes.entries) {
      final key = entry.key.toString().toLowerCase();
      final value = entry.value.toString();
      if (loweredNames.contains(key) && value.isNotEmpty) {
        return entry.value;
      }
    }
    return null;
  }

  static String _decodeXmlEntities(String input) {
    var out = input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");

    out = out.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      final code = int.tryParse(match.group(1)!);
      if (code == null || code < 0 || code > 0x10FFFF) {
        return match.group(0)!;
      }
      return String.fromCharCode(code);
    });

    out = out.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (match) {
      final code = int.tryParse(match.group(1)!, radix: 16);
      if (code == null || code < 0 || code > 0x10FFFF) {
        return match.group(0)!;
      }
      return String.fromCharCode(code);
    });

    return out;
  }
}

class OpmlPodcastInfo {
  final String title;
  final String feedUrl;
  bool selected;

  OpmlPodcastInfo({
    required this.title,
    required this.feedUrl,
    this.selected = true,
  });

  OpmlPodcastInfo copyWith({
    String? title,
    String? feedUrl,
    bool? selected,
  }) {
    return OpmlPodcastInfo(
      title: title ?? this.title,
      feedUrl: feedUrl ?? this.feedUrl,
      selected: selected ?? this.selected,
    );
  }
}
