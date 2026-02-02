import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// 主题配置类
class AppThemeConfig {
  final String id;
  final String name;
  final ThemeMode mode;
  final bool isCustom;

  // 预设主题使用的FlexScheme
  final FlexScheme? flexScheme;

  // 自定义主题使用的颜色
  final Color? primaryColor;
  final Color? secondaryColor;

  // 深色主题混合级别 (0-20)
  final int blendLevel;

  const AppThemeConfig({
    required this.id,
    required this.name,
    required this.mode,
    this.isCustom = false,
    this.flexScheme,
    this.primaryColor,
    this.secondaryColor,
    this.blendLevel = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mode': mode.name,
      'isCustom': isCustom,
      'flexScheme': flexScheme?.name,
      'primaryColor': primaryColor?.value,
      'secondaryColor': secondaryColor?.value,
      'blendLevel': blendLevel,
    };
  }

  factory AppThemeConfig.fromJson(Map<String, dynamic> json) {
    return AppThemeConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      mode: ThemeMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => ThemeMode.light,
      ),
      isCustom: json['isCustom'] as bool? ?? false,
      flexScheme: json['flexScheme'] != null
          ? FlexScheme.values.firstWhere(
              (e) => e.name == json['flexScheme'],
              orElse: () => FlexScheme.aquaBlue,
            )
          : null,
      primaryColor: json['primaryColor'] != null
          ? Color(json['primaryColor'] as int)
          : null,
      secondaryColor: json['secondaryColor'] != null
          ? Color(json['secondaryColor'] as int)
          : null,
      blendLevel: json['blendLevel'] as int? ?? 10,
    );
  }
}

/// 预设主题枚举 - 8种日本传统色
enum AppThemePreset {
  enshuNezumi, // 远洲鼠
  ochiguri, // 落栗
  suou, // 苏芳
  sekichiku, // 石竹
  karekusa, // 枯草
  yanagisusutake, // 柳煤竹茶
  sabiseiji, // 锖青磁
  hatobamurasaki, // 鸠羽紫
}

/// 预设主题配置 - 坚果手机文青版8种日本传统色
final Map<AppThemePreset, AppThemeConfig> themePresets = {
  AppThemePreset.enshuNezumi: const AppThemeConfig(
    id: 'enshu_nezumi',
    name: '远洲鼠',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFFCA8269), // #CA8269
    blendLevel: 0, // 米色背景不需要混合
  ),
  AppThemePreset.ochiguri: const AppThemeConfig(
    id: 'ochiguri',
    name: '落栗',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFF762F07), // #762F07
    blendLevel: 0,
  ),
  AppThemePreset.suou: const AppThemeConfig(
    id: 'suou',
    name: '苏芳',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFF7E2639), // #7E2639
    blendLevel: 0,
  ),
  AppThemePreset.sekichiku: const AppThemeConfig(
    id: 'sekichiku',
    name: '石竹',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFFE5ABBE), // #E5ABBE
    blendLevel: 0,
  ),
  AppThemePreset.karekusa: const AppThemeConfig(
    id: 'karekusa',
    name: '枯草',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFFE4DC8A), // #E4DC8A
    blendLevel: 0,
  ),
  AppThemePreset.yanagisusutake: const AppThemeConfig(
    id: 'yanagisusutake',
    name: '柳煤竹茶',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFF635B44), // #635B44
    blendLevel: 0,
  ),
  AppThemePreset.sabiseiji: const AppThemeConfig(
    id: 'sabiseiji',
    name: '锖青磁',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFF898A74), // #898A74
    blendLevel: 0,
  ),
  AppThemePreset.hatobamurasaki: const AppThemeConfig(
    id: 'hatobamurasaki',
    name: '鸠羽紫',
    mode: ThemeMode.light,
    isCustom: true,
    primaryColor: Color(0xFF6C6A6D), // #6C6A6D
    blendLevel: 0,
  ),
};
