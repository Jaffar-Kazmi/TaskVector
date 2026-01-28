import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsDb {

  static Future<void> saveTheme(ThemeMode themeMode) async {
    final box = await Hive.openBox('settings');
    box.put('themeMode', themeMode.index);
  }

  static Future<ThemeMode> loadTheme() async {
    final box = await Hive.openBox('settings');
    final int? index = box.get('themeMode');

    if (index == null) return ThemeMode.system;

    switch (index) {
      case 0: return ThemeMode.light;
      case 1: return ThemeMode.system;
      case 2: return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}