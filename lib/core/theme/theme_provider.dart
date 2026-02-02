import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../services/storage/storage_service.dart';
import '../providers/providers.dart';
import 'theme_config.dart';

/// 主题状态管理
class ThemeNotifier extends StateNotifier<AppThemeConfig> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService)
      : super(themePresets[AppThemePreset.enshuNezumi]!) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await _storageService.loadTheme();
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  Future<void> setPresetTheme(AppThemePreset preset) async {
    final theme = themePresets[preset]!;
    await setTheme(theme);
  }

  Future<void> setTheme(AppThemeConfig theme) async {
    state = theme;
    await _storageService.saveTheme(theme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeConfig>(
  (ref) {
    final storageService = ref.watch(storageServiceProvider);
    return ThemeNotifier(storageService);
  },
);

/// 生成浅色主题
ThemeData buildLightTheme(AppThemeConfig config) {
  if (config.isCustom && config.primaryColor != null) {
    // 日本传统色主题 - 米色背景
    const beige = Color(0xFFF5F1E8); // 米色背景
    final primary = config.primaryColor!;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primary.withOpacity(0.2),
        onPrimaryContainer: primary,
        secondary: primary,
        onSecondary: Colors.white,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
        surface: beige,
        onSurface: const Color(0xFF1C1B1F),
        surfaceContainerLowest: beige,
        surfaceContainerLow: beige,
        surfaceContainer: beige,
        surfaceContainerHigh: beige,
        surfaceContainerHighest: beige,
        outline: primary.withOpacity(0.5),
      ),
      scaffoldBackgroundColor: beige,
      textTheme: GoogleFonts.interTextTheme(),
    );
  } else {
    // 预设Flex Scheme主题
    return FlexThemeData.light(
      scheme: config.flexScheme ?? FlexScheme.indigo,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: config.blendLevel,
      textTheme: GoogleFonts.interTextTheme(),
    );
  }
}

/// 生成深色主题
ThemeData buildDarkTheme(AppThemeConfig config) {
  if (config.isCustom && config.primaryColor != null) {
    // 自定义颜色主题
    return FlexThemeData.dark(
      colors: FlexSchemeColor.from(
        primary: config.primaryColor!,
        secondary: config.secondaryColor ?? config.primaryColor!,
      ),
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: config.blendLevel,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  } else {
    // 预设FlexScheme主题
    return FlexThemeData.dark(
      scheme: config.flexScheme ?? FlexScheme.indigo,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: config.blendLevel,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
