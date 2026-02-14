import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/storage/storage_service.dart';
import '../providers/providers.dart';
import 'theme_config.dart';

/// 主题状态管理
class ThemeNotifier extends StateNotifier<AppThemeConfig> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService) : super(defaultThemeConfig) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await _storageService.loadTheme();
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  Future<void> setTheme(AppThemeConfig theme) async {
    state = theme;
    await _storageService.saveTheme(theme);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final newTheme = AppThemeConfig(
      id: state.id,
      name: state.name,
      mode: mode,
    );
    await setTheme(newTheme);
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
  return baseTheme.copyWith(
    displayLarge: baseTheme.displayLarge
        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0),
    displayMedium: baseTheme.displayMedium
        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
    displaySmall: baseTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
    headlineLarge: baseTheme.headlineLarge
        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
    headlineMedium:
        baseTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
    headlineSmall:
        baseTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    titleLarge: baseTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    titleMedium: baseTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    titleSmall: baseTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    bodyLarge: baseTheme.bodyLarge,
    bodyMedium: baseTheme.bodyMedium,
    bodySmall: baseTheme.bodySmall,
    labelLarge: baseTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}

/// 创建浅色配色方案
ColorScheme _buildLightColorScheme() {
  return ColorScheme.light(
    primary: AppColors.vermillion,
    onPrimary: Colors.white,
    primaryContainer: AppColors.peachBlossom.withOpacity(0.3),
    onPrimaryContainer: AppColors.indigo,
    secondary: AppColors.bambooGreen,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.teaGreen.withOpacity(0.5),
    onSecondaryContainer: AppColors.indigo,
    tertiary: AppColors.peachBlossom,
    onTertiary: AppColors.indigo,
    tertiaryContainer: AppColors.peachBlossom.withOpacity(0.2),
    onTertiaryContainer: AppColors.indigo,
    error: const Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
    surface: AppColors.ricePaper,
    onSurface: AppColors.indigo,
    surfaceContainerHighest: AppColors.softBeige,
    onSurfaceVariant: AppColors.indigo.withOpacity(0.8),
    outline: AppColors.teaGreen,
    outlineVariant: AppColors.teaGreen.withOpacity(0.5),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.indigo,
    onInverseSurface: AppColors.ricePaper,
    inversePrimary: AppColors.peachBlossom,
  );
}

/// 创建深色配色方案
ColorScheme _buildDarkColorScheme() {
  return ColorScheme.dark(
    primary: AppColors.peachBlossom,
    onPrimary: AppColors.indigo,
    primaryContainer: AppColors.vermillion.withOpacity(0.6),
    onPrimaryContainer: Colors.white,
    secondary: AppColors.teaGreen,
    onSecondary: AppColors.indigo,
    secondaryContainer: AppColors.bambooGreen.withOpacity(0.6),
    onSecondaryContainer: Colors.white,
    tertiary: AppColors.peachBlossom.withOpacity(0.8),
    onTertiary: AppColors.indigo,
    tertiaryContainer: AppColors.vermillion.withOpacity(0.4),
    onTertiaryContainer: Colors.white,
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    errorContainer: const Color(0xFF93000A),
    onErrorContainer: const Color(0xFFFFDAD6),
    surface: const Color(0xFF1A1C1E),
    onSurface: const Color(0xFFE3E2E6),
    surfaceContainerHighest: const Color(0xFF44464F),
    onSurfaceVariant: const Color(0xFFC5C6D0),
    outline: AppColors.teaGreen.withOpacity(0.6),
    outlineVariant: const Color(0xFF44464F),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: const Color(0xFFE3E2E6),
    onInverseSurface: const Color(0xFF1A1C1E),
    inversePrimary: AppColors.vermillion,
  );
}

/// 生成浅色主题
ThemeData buildLightTheme(AppThemeConfig config) {
  final colorScheme = _buildLightColorScheme();
  final textTheme = _buildExpressiveTextTheme(ThemeData.light().textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.ricePaper,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.ricePaper,
      foregroundColor: AppColors.indigo,
      elevation: 0,
      centerTitle: false,
    ),

    // Card
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    // FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.vermillion,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.teaGreen.withOpacity(0.3),
      selectedColor: AppColors.bambooGreen,
      labelStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.softBeige,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.vermillion, width: 2),
      ),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: AppColors.teaGreen.withOpacity(0.3),
      thickness: 1,
    ),
  );
}

/// 生成深色主题
ThemeData buildDarkTheme(AppThemeConfig config) {
  final colorScheme = _buildDarkColorScheme();
  final textTheme = _buildExpressiveTextTheme(ThemeData.dark().textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: const Color(0xFF1A1C1E),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1C1E),
      foregroundColor: Color(0xFFE3E2E6),
      elevation: 0,
      centerTitle: false,
    ),

    // Card
    cardTheme: CardThemeData(
      color: const Color(0xFF2C2E30),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    // FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.peachBlossom,
      foregroundColor: AppColors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.bambooGreen.withOpacity(0.3),
      selectedColor: AppColors.teaGreen,
      labelStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2E30),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.peachBlossom, width: 2),
      ),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: AppColors.bambooGreen.withOpacity(0.3),
      thickness: 1,
    ),
  );
}
