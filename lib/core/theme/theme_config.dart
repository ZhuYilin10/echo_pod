import 'package:flutter/material.dart';

/// 应用配色常量
class AppColors {
  // Primary - 朱砂 (Vermillion)
  static const vermillion = Color(0xFFE35D6A);

  // Core Palette
  static const peachBlossom = Color(0xFFF5A6B5);
  static const bambooGreen = Color(0xFF6B8E77);
  static const teaGreen = Color(0xFFA8BFA3);
  static const indigo = Color(0xFF2C4A6E);

  // Neutral backgrounds
  static const ricePaper = Color(0xFFF9F5F1); // 宣纸
  static const softBeige = Color(0xFFF5F1E8);
}

/// 主题配置类
class AppThemeConfig {
  final String id;
  final String name;
  final ThemeMode mode;

  const AppThemeConfig({
    required this.id,
    required this.name,
    required this.mode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mode': mode.name,
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
    );
  }
}

/// 默认主题配置
const defaultThemeConfig = AppThemeConfig(
  id: 'default',
  name: '默认主题',
  mode: ThemeMode.light,
);
