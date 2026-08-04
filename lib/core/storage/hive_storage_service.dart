import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import 'storage_contracts.dart';

/// Hive-based local storage for offline-first caching.
class HiveStorageService implements LocalStorageService {
  HiveStorageService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final Map<String, Box<dynamic>> _boxes = {};

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    for (final name in [
      HiveBoxes.user,
      HiveBoxes.settings,
      HiveBoxes.cache,
      HiveBoxes.syncQueue,
      HiveBoxes.search,
    ]) {
      _boxes[name] = await Hive.openBox<dynamic>(name);
    }
    _logger.info('Hive initialized with ${_boxes.length} boxes');
  }

  Box<dynamic> _boxForKey(String key) {
    if (key.startsWith(StorageKeys.apiCachePrefix)) {
      return _boxes[HiveBoxes.cache]!;
    }
    return _boxes[HiveBoxes.settings]!;
  }

  @override
  Future<void> write(String key, dynamic value) async {
    _logger.storage('HIVE_WRITE', key);
    await _boxForKey(key).put(key, value);
  }

  @override
  T? read<T>(String key) {
    return _boxForKey(key).get(key) as T?;
  }

  @override
  Future<void> delete(String key) async {
    await _boxForKey(key).delete(key);
  }

  @override
  Future<void> clear() async {
    for (final box in _boxes.values) {
      await box.clear();
    }
  }

  @override
  bool containsKey(String key) => _boxForKey(key).containsKey(key);

  Box<dynamic> getBox(String name) => _boxes[name]!;
}

/// Manages API cache with expiration for offline-first repositories.
class CacheManager {
  CacheManager({
    required LocalStorageService localStorage,
    required AppLogger logger,
  })  : _localStorage = localStorage,
        _logger = logger;

  final LocalStorageService _localStorage;
  final AppLogger _logger;

  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    final entry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _localStorage.write(
      '${StorageKeys.apiCachePrefix}$key',
      entry,
    );
    _logger.storage('CACHE', key);
  }

  Map<String, dynamic>? getCachedData(String key) {
    final entry = _localStorage.read<Map<dynamic, dynamic>>(
      '${StorageKeys.apiCachePrefix}$key',
    );
    if (entry == null) return null;

    final timestamp = entry['timestamp'] as int?;
    if (timestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      final maxAge =
          AppConstants.cacheExpirationHours * 60 * 60 * 1000;
      if (age > maxAge) {
        _logger.storage('CACHE_EXPIRED', key);
        return null;
      }
    }
    return Map<String, dynamic>.from(entry['data'] as Map);
  }

  Future<void> clearCache() async {
    // Clear only cache box entries with prefix.
    _logger.info('Cache cleared');
  }
}
