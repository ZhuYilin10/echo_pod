import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';

class WebPodcastService {
  // Logic to handle web-based audio extraction
  // This will eventually be a full service, but for now, we'll use it via the UI
}

class WebPlayerWidget extends ConsumerStatefulWidget {
  final String url;
  final Episode episode;
  final Function(Duration position, Duration duration) onProgress;

  const WebPlayerWidget({
    super.key,
    required this.url,
    required this.episode,
    required this.onProgress,
  });

  @override
  ConsumerState<WebPlayerWidget> createState() => _WebPlayerWidgetState();
}

class _WebPlayerWidgetState extends ConsumerState<WebPlayerWidget> {
  InAppWebViewController? _webViewController;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1, // Keep it nearly invisible
      width: 1,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1",
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          // Inject JS to find video and control it
          await _injectPlayerControl();
        },
      ),
    );
  }

  Future<void> _injectPlayerControl() async {
    if (_webViewController == null) return;

    // JavaScript to:
    // 1. Find the video element
    // 2. Play it
    // 3. Report progress back to Flutter
    const js = """
      (function() {
        var video = document.querySelector('video');
        if (video) {
          video.play();
          video.addEventListener('timeupdate', function() {
            window.flutter_inappwebview.callHandler('onProgress', {
              position: video.currentTime,
              duration: video.duration
            });
          });
          video.addEventListener('play', function() {
            window.flutter_inappwebview.callHandler('onStateChanged', { playing: true });
          });
          video.addEventListener('pause', function() {
            window.flutter_inappwebview.callHandler('onStateChanged', { playing: false });
          });
        }
      })();
    """;

    await _webViewController!.evaluateJavascript(source: js);

    _webViewController!.addJavaScriptHandler(
      handlerName: 'onProgress',
      callback: (args) {
        final pos = args[0]['position'] as double;
        final dur = args[0]['duration'] as double;
        widget.onProgress(
          Duration(milliseconds: (pos * 1000).toInt()),
          Duration(milliseconds: (dur * 1000).toInt()),
        );
      },
    );
  }
}
