import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'services/storage/storage_service.dart';
import 'services/audio/audio_handler.dart';
import 'services/platform/live_activity_service.dart';
import 'core/providers/providers.dart';
import 'core/theme/theme_provider.dart';

import 'features/navigation_wrapper.dart';

late EchoPodAudioHandler _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class EchoPodApp extends ConsumerWidget {
  const EchoPodApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeProvider);

    return MaterialApp(
      title: 'EchoPod AI',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(themeConfig),
      darkTheme: buildDarkTheme(themeConfig),
      themeMode: themeConfig.mode,
      home: const MainNavigationWrapper(),
    );
  }
}
