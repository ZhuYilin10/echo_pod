import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'services/storage/storage_service.dart';
import 'services/audio/audio_handler.dart';
import 'services/platform/live_activity_service.dart';
import 'core/providers/providers.dart';

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

class EchoPodApp extends StatelessWidget {
  const EchoPodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoPod AI',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.deepPurple,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.deepPurple,
        useMaterial3: true,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.dark,
      home: const MainNavigationWrapper(),
    );
  }
}
