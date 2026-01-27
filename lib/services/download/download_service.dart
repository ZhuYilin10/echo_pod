import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadService {
  final Dio _dio = Dio();
  
  // Track download status
  Future<bool> isDownloaded(String audioUrl) async {
    final file = File(await _getLocalPath(audioUrl));
    return file.existsSync();
  }

  Future<String> _getLocalPath(String audioUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = audioUrl.split('/').last.split('?').first;
    return '${directory.path}/downloads/$fileName';
  }

  Future<void> downloadEpisode(String audioUrl, Function(double) onProgress) async {
    final savePath = await _getLocalPath(audioUrl);
    final file = File(savePath);
    
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }

    try {
      await _dio.download(
        audioUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );
    } catch (e) {
      print('Download error: $e');
      rethrow;
    }
  }

  Future<String?> getOfflinePath(String audioUrl) async {
    if (await isDownloaded(audioUrl)) {
      return await _getLocalPath(audioUrl);
    }
    return null;
  }

  Future<void> deleteDownload(String audioUrl) async {
    final path = await _getLocalPath(audioUrl);
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
