import 'dart:convert';

import 'package:isar/isar.dart';

import '../db/database_service.dart';
import '../db/entities/app_setting_entity.dart';
import '../../core/theme/theme_config.dart';

class SettingsRepository {
  SettingsRepository({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  final DatabaseService _dbService;

  Future<void> setString(String key, String value) async {
    await _upsert(key, stringValue: value);
  }

  Future<String?> getString(String key) async {
    final db = await _dbService.isar;
    final row = await db.appSettingEntitys.filter().keyEqualTo(key).findFirst();
    return row?.stringValue;
  }

  Future<void> setInt(String key, int value) async {
    await _upsert(key, intValue: value);
  }

  Future<int?> getInt(String key) async {
    final db = await _dbService.isar;
    final row = await db.appSettingEntitys.filter().keyEqualTo(key).findFirst();
    return row?.intValue;
  }

  Future<void> setDouble(String key, double value) async {
    await _upsert(key, doubleValue: value);
  }

  Future<double?> getDouble(String key) async {
    final db = await _dbService.isar;
    final row = await db.appSettingEntitys.filter().keyEqualTo(key).findFirst();
    return row?.doubleValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _upsert(key, boolValue: value);
  }

  Future<bool?> getBool(String key) async {
    final db = await _dbService.isar;
    final row = await db.appSettingEntitys.filter().keyEqualTo(key).findFirst();
    return row?.boolValue;
  }

  Future<void> remove(String key) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final row =
          await db.appSettingEntitys.filter().keyEqualTo(key).findFirst();
      if (row != null) {
        await db.appSettingEntitys.delete(row.isarId);
      }
    });
  }

  Future<void> saveTheme(AppThemeConfig theme) async {
    await setString('app_theme_config', jsonEncode(theme.toJson()));
  }

  Future<AppThemeConfig?> loadTheme() async {
    final raw = await getString('app_theme_config');
    if (raw == null || raw.isEmpty) return null;
    try {
      return AppThemeConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _upsert(
    String key, {
    String? stringValue,
    int? intValue,
    double? doubleValue,
    bool? boolValue,
  }) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final row = await db.appSettingEntitys
              .filter()
              .keyEqualTo(key)
              .findFirst() ??
          AppSettingEntity()
        ..key = key;
      row.stringValue = stringValue;
      row.intValue = intValue;
      row.doubleValue = doubleValue;
      row.boolValue = boolValue;
      row.updatedAt = DateTime.now();
      await db.appSettingEntitys.put(row);
    });
  }
}
