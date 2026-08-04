import 'package:shared_preferences/shared_preferences.dart';

import '../logger/app_logger.dart';
import 'storage_contracts.dart';

/// SharedPreferences wrapper for non-sensitive settings.
class PreferencesServiceImpl implements PreferencesService {
  PreferencesServiceImpl({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    assert(_prefs != null, 'PreferencesService not initialized');
    return _prefs!;
  }

  @override
  Future<bool> setString(String key, String value) {
    _logger.storage('SET', key, value);
    return _instance.setString(key, value);
  }

  @override
  String? getString(String key) => _instance.getString(key);

  @override
  Future<bool> setBool(String key, bool value) {
    _logger.storage('SET', key, value);
    return _instance.setBool(key, value);
  }

  @override
  bool? getBool(String key) => _instance.getBool(key);

  @override
  Future<bool> setInt(String key, int value) {
    _logger.storage('SET', key, value);
    return _instance.setInt(key, value);
  }

  @override
  int? getInt(String key) => _instance.getInt(key);

  @override
  Future<bool> remove(String key) => _instance.remove(key);

  @override
  Future<bool> clear() => _instance.clear();
}
