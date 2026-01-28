import 'package:flutter/material.dart';
import 'package:taskvector/services/settings_db.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    _themeMode = await SettingsDb.loadTheme();
    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    await SettingsDb.saveTheme(mode);
    _themeMode = mode;
    notifyListeners();
  }

}