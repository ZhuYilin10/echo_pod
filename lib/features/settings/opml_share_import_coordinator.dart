import 'package:flutter/material.dart';
import '../../services/sharing/sharing_service.dart';
import 'opml_import_screen.dart';

/// Handles pending OPML share records saved by iOS Share Extension.
/// Flow:
/// 1) Read pending metadata from App Group.
/// 2) Parse OPML file and navigate to import screen.
/// 3) Clear pending metadata only after successful handling.
class OpmlShareImportCoordinator {
  OpmlShareImportCoordinator(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;
  bool _isCheckingPendingShare = false;
  bool _isHandlingSharedFile = false;

  Future<void> checkAndHandlePendingShare() async {
    if (_isCheckingPendingShare) return;
    _isCheckingPendingShare = true;
    try {
      final result = await SharingService.checkPendingSharedFile();
      if (result == null) return;

      final filePath = result['filePath'] as String?;
      final fileName = result['fileName'] as String?;
      if (filePath == null || fileName == null) return;

      final handled = await _handleSharedFile(
        filePath: filePath,
        fileName: fileName,
      );
      if (handled) {
        await SharingService.clearPendingSharedFile();
      }
    } catch (e) {
      debugPrint('[OpmlShareImportCoordinator] pending share error: $e');
    } finally {
      _isCheckingPendingShare = false;
    }
  }

  Future<bool> _handleSharedFile({
    required String filePath,
    required String fileName,
  }) async {
    if (_isHandlingSharedFile) return false;
    if (filePath.isEmpty) return true;

    _isHandlingSharedFile = true;
    try {
      final opmlContent = await SharingService.readOpmlFile(filePath);
      if (opmlContent == null) {
        _showMessage(_navigatorKey.currentContext, '无法读取 OPML 文件');
        return true;
      }

      final podcasts = SharingService.parseOpmlPodcasts(opmlContent);
      if (podcasts.isEmpty) {
        _showMessage(_navigatorKey.currentContext, 'OPML 文件中未找到播客订阅');
        return true;
      }

      final navigator = _navigatorKey.currentState;
      if (navigator != null) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => OpmlImportScreen(podcasts: podcasts),
          ),
        );
        return true;
      }

      debugPrint(
        '[OpmlShareImportCoordinator] navigator unavailable for shared file: $fileName',
      );
      return false;
    } finally {
      _isHandlingSharedFile = false;
    }
  }

  void _showMessage(BuildContext? context, String message) {
    if (context == null || !context.mounted) return;
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
