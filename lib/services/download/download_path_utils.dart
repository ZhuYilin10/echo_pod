import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../db/db_utils.dart';

Future<String> buildDownloadPathFromUrl(String mediaUrl) async {
  final directory = await getApplicationDocumentsDirectory();
  final extension = extensionFromUrl(mediaUrl, fallback: 'bin');
  final normalized = normalizeUrl(mediaUrl);
  final fileName = 'media_${stableSha1(normalized)}.$extension';
  return '${directory.path}/downloads/$fileName';
}

File downloadFileFromPath(String path) => File(path);
