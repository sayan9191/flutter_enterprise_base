import 'package:flutter/material.dart';

import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import '../storage/storage_contracts.dart';

/// Manages locale persistence and notifications.
class LocaleManager extends ChangeNotifier {
  LocaleManager({
    required PreferencesService preferences,
    required AppLogger logger,
  })  : _preferences = preferences,
        _logger = logger;

  final PreferencesService _preferences;
  final AppLogger _logger;

  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> init() async {
    final stored = _preferences.getString(StorageKeys.locale);
    if (stored != null) {
      _locale = Locale(stored);
    }
    _logger.info('Locale: $_locale');
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _preferences.setString(StorageKeys.locale, locale.languageCode);
    notifyListeners();
  }
}
