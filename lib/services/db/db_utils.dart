import 'dart:convert';

import 'package:crypto/crypto.dart';

String stableSha1(String input) => sha1.convert(utf8.encode(input)).toString();

String normalizeUrl(
  String input, {
  Set<String> queryWhitelist = const {},
}) {
  final raw = input.trim();
  if (raw.isEmpty) return raw;

  Uri? uri = Uri.tryParse(raw);
  if (uri == null) return raw;

  if (!uri.hasScheme) {
    final withScheme = 'https://$raw';
    uri = Uri.tryParse(withScheme);
    if (uri == null) return raw;
  }

  final scheme = uri.scheme.toLowerCase();
  final host = uri.host.toLowerCase();
  final port = (uri.hasPort &&
          !((scheme == 'http' && uri.port == 80) ||
              (scheme == 'https' && uri.port == 443)))
      ? uri.port
      : null;

  final normalizedPath = _normalizePath(uri.path);

  final filteredQuery = <String, String>{};
  final keys = uri.queryParameters.keys.toList()..sort();
  for (final key in keys) {
    if (queryWhitelist.isEmpty || queryWhitelist.contains(key)) {
      final value = uri.queryParameters[key];
      if (value != null) filteredQuery[key] = value;
    }
  }

  final normalized = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: normalizedPath,
    queryParameters: filteredQuery.isEmpty ? null : filteredQuery,
    fragment: null,
  );

  return normalized.toString();
}

String podcastUidFromCanonicalUrl(String canonicalUrl) {
  return 'pod_${stableSha1(canonicalUrl)}';
}

String buildEpisodeFingerprint({
  required String podcastUid,
  String? guid,
  String? normalizedEnclosureUrl,
  String? title,
  DateTime? pubDate,
}) {
  if (guid != null && guid.trim().isNotEmpty) {
    return stableSha1('$podcastUid|guid|${guid.trim()}');
  }

  if (normalizedEnclosureUrl != null && normalizedEnclosureUrl.isNotEmpty) {
    return stableSha1('$podcastUid|url|$normalizedEnclosureUrl');
  }

  final safeTitle = (title ?? '').trim().toLowerCase();
  final minuteBucket = pubDate == null
      ? ''
      : DateTime(pubDate.year, pubDate.month, pubDate.day, pubDate.hour,
              pubDate.minute)
          .toIso8601String();
  return stableSha1('$podcastUid|fallback|$safeTitle|$minuteBucket');
}

String episodeUidFromFingerprint(String fingerprint) {
  return 'ep_$fingerprint';
}

String mediaUidFromUrl(String episodeUid, String normalizedUrl) {
  return 'media_${stableSha1('$episodeUid|$normalizedUrl')}';
}

String cacheCanonicalUrl(String cacheKey) {
  return 'cache://${cacheKey.trim()}';
}

String _normalizePath(String path) {
  if (path.isEmpty) return '/';
  if (path.length > 1 && path.endsWith('/')) {
    return path.substring(0, path.length - 1);
  }
  return path;
}

int? parseDurationToMs(String? duration) {
  if (duration == null || duration.trim().isEmpty) return null;
  final raw = duration.trim();

  int parsePart(String part) {
    if (part.contains('.')) {
      return double.tryParse(part)?.toInt() ?? 0;
    }
    return int.tryParse(part) ?? 0;
  }

  if (raw.contains(':')) {
    final parts = raw.split(':');
    if (parts.length == 3) {
      final h = parsePart(parts[0]);
      final m = parsePart(parts[1]);
      final s = parsePart(parts[2]);
      return Duration(hours: h, minutes: m, seconds: s).inMilliseconds;
    }
    if (parts.length == 2) {
      final m = parsePart(parts[0]);
      final s = parsePart(parts[1]);
      return Duration(minutes: m, seconds: s).inMilliseconds;
    }
  }

  final asSeconds = parsePart(raw);
  return Duration(seconds: asSeconds).inMilliseconds;
}

String extensionFromUrl(String url, {String fallback = 'bin'}) {
  final uri = Uri.tryParse(url);
  final path = uri?.path ?? url;
  final lastSegment = path.split('/').where((s) => s.isNotEmpty).lastOrNull;
  if (lastSegment == null || !lastSegment.contains('.')) return fallback;
  final ext = lastSegment.split('.').last.toLowerCase();
  if (ext.isEmpty || ext.length > 8) return fallback;
  return ext;
}

String sanitizeUtf16(String input) {
  if (input.isEmpty) return input;

  final units = input.codeUnits;
  final buffer = StringBuffer();
  var i = 0;

  while (i < units.length) {
    final current = units[i];

    if (_isHighSurrogate(current)) {
      if (i + 1 < units.length && _isLowSurrogate(units[i + 1])) {
        buffer.writeCharCode(current);
        buffer.writeCharCode(units[i + 1]);
        i += 2;
        continue;
      }
      i += 1;
      continue;
    }

    if (_isLowSurrogate(current)) {
      i += 1;
      continue;
    }

    buffer.writeCharCode(current);
    i += 1;
  }

  return buffer.toString();
}

String? sanitizeAndTruncate(String? input, {int? maxChars}) {
  if (input == null) return null;
  var value = sanitizeUtf16(input);
  if (maxChars != null && value.length > maxChars) {
    value = value.substring(0, maxChars);
    if (value.isNotEmpty &&
        _isHighSurrogate(value.codeUnitAt(value.length - 1))) {
      value = value.substring(0, value.length - 1);
    }
  }
  return value;
}

bool _isHighSurrogate(int codeUnit) => codeUnit >= 0xD800 && codeUnit <= 0xDBFF;

bool _isLowSurrogate(int codeUnit) => codeUnit >= 0xDC00 && codeUnit <= 0xDFFF;

extension _LastOrNull<T> on Iterable<T> {
  T? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }
}
