import 'package:flutter/material.dart';

import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import '../storage/storage_contracts.dart';

/// Manages theme mode persistence and notifications.
class ThemeManager extends ChangeNotifier {
  ThemeManager({
    required PreferencesService preferences,
    required AppLogger logger,
  })  : _preferences = preferences,
        _logger = logger;

  final PreferencesService _preferences;
  final AppLogger _logger;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    final stored = _preferences.getString(StorageKeys.themeMode);
    _themeMode = _parseThemeMode(stored);
    _logger.info('Theme mode: $_themeMode');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _preferences.setString(StorageKeys.themeMode, mode.name);
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
