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

/// 构建 M3 Expressive 混合字体
TextTheme _buildExpressiveTextTheme(TextTheme? base) {
  final baseTheme = base ?? ThemeData.light().textTheme;
  final outfit = GoogleFonts.outfitTextTheme(baseTheme);
  final inter = GoogleFonts.interTextTheme(baseTheme);

  return inter.copyWith(
    displayLarge: outfit.displayLarge
        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0),
    displayMedium: outfit.displayMedium
        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
    displaySmall: outfit.displaySmall?.copyWith(fontWeight: FontWeight.w800),
    headlineLarge: outfit.headlineLarge
        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
    headlineMedium:
        outfit.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
    headlineSmall: outfit.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    titleLarge: outfit.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    titleMedium: outfit.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    titleSmall: outfit.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    // Keep Inter for Body/Label for readability
    bodyLarge: inter.bodyLarge,
    bodyMedium: inter.bodyMedium,
    bodySmall: inter.bodySmall,
    labelLarge: inter.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}

/// M3 Expressive 子组件主题配置
const _expressiveSubThemes = FlexSubThemesData(
  blendOnLevel: 10,
  blendTextTheme: true,
  useTextTheme: true,
  useM2StyleDividerInM3: true,
  defaultRadius: 24.0, // Extra Large Shapes
  thinBorderWidth: 1.0,
  thickBorderWidth: 2.0,

  inputDecoratorRadius: 16.0,
  fabUseShape: true,
  fabRadius: 16.0,
  chipRadius: 12.0,
  cardElevation: 0.5,
  popupMenuRadius: 12.0,
  alignedDropdown: true,
  useInputDecoratorThemeInDialogs: true,
);

/// 生成浅色主题
ThemeData buildLightTheme(AppThemeConfig config) {
  final textTheme = _buildExpressiveTextTheme(ThemeData.light().textTheme);

  if (config.isCustom && config.primaryColor != null) {
    // 日本传统色主题
    final primary = config.primaryColor!;

    return FlexThemeData.light(
      colors: FlexSchemeColor.from(
        primary: primary,
        secondary: primary,
        tertiary: primary.withOpacity(0.5),
      ),
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface, // More modern look
      blendLevel: 10, // Slight blend for harmony
      subThemesData: _expressiveSubThemes.copyWith(
        blendOnLevel: 10,
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      textTheme: textTheme,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  } else {
    // 预设Flex Scheme主题
    return FlexThemeData.light(
      scheme: config.flexScheme ?? FlexScheme.indigo,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: config.blendLevel,
      subThemesData: _expressiveSubThemes,
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      textTheme: textTheme,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }
}

/// 生成深色主题
ThemeData buildDarkTheme(AppThemeConfig config) {
  final textTheme = _buildExpressiveTextTheme(ThemeData.dark().textTheme);

  // Common dark theme settings
  final darkSubThemes = _expressiveSubThemes.copyWith(
    blendOnLevel: 20,
  );

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
      subThemesData: darkSubThemes,
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      textTheme: textTheme,
    );
  } else {
    // 预设FlexScheme主题
    return FlexThemeData.dark(
      scheme: config.flexScheme ?? FlexScheme.indigo,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: config.blendLevel,
      subThemesData: darkSubThemes,
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      textTheme: textTheme,
    );
  }
}
