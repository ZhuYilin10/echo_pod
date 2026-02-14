import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'services/storage/storage_service.dart';
import 'services/audio/audio_handler.dart';
import 'services/db/database_service.dart';
import 'services/platform/live_activity_service.dart';
import 'core/providers/providers.dart';
import 'core/theme/theme_provider.dart';

import 'features/navigation_wrapper.dart';
import 'features/settings/opml_share_import_coordinator.dart';

late EchoPodAudioHandler _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.initialize();

  final liveActivityService = LiveActivityService();
  final storageService = StorageService();

  _audioHandler = await AudioService.init(
    builder: () => EchoPodAudioHandler(liveActivityService, storageService),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.echopod.audio',
      androidNotificationChannelName: 'EchoPod Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(_audioHandler),
      ],
      child: const EchoPodApp(),
    ),
  );
}

class EchoPodApp extends ConsumerStatefulWidget {
  const EchoPodApp({super.key});

  @override
  ConsumerState<EchoPodApp> createState() => _EchoPodAppState();
}

class _EchoPodAppState extends ConsumerState<EchoPodApp>
    with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final OpmlShareImportCoordinator _opmlShareImportCoordinator;

  @override
  void initState() {
    super.initState();
    _opmlShareImportCoordinator = OpmlShareImportCoordinator(_navigatorKey);
    WidgetsBinding.instance.addObserver(this);
    // 首帧后检查一次 pending 分享
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _opmlShareImportCoordinator.checkAndHandlePendingShare();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _opmlShareImportCoordinator.checkAndHandlePendingShare();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = ref.watch(themeProvider);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'EchoPod AI',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(themeConfig),
      darkTheme: buildDarkTheme(themeConfig),
      themeMode: themeConfig.mode,
      home: const MainNavigationWrapper(),
    );
  }
}
