import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();
  final _progressController = StreamController<Map<String, double>>.broadcast();

  Stream<Map<String, double>> get downloadProgressStream =>
      _progressController.stream;

  Future<bool> isDownloaded(String audioUrl) async {
    final path = await _getLocalPath(audioUrl);
    final file = File(path);
    return file.existsSync();
  }

  Future<String> _getLocalPath(String audioUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = audioUrl.split('/').last.split('?').first;
    return '${directory.path}/downloads/$fileName';
  }

  Future<void> downloadEpisode(
      String audioUrl, Function(double) onProgress) async {
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
            final progress = received / total;
            onProgress(progress);
            _progressController.add({audioUrl: progress});
          }
        },
      );
      _progressController.add({audioUrl: 1.0}); // Ensure 100% is sent
    } catch (_) {
      _progressController.add({audioUrl: -1.0}); // Error state
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
