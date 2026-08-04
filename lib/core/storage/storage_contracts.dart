/// Storage service contracts — implementations must not be used directly from UI.
abstract class LocalStorageService {
  Future<void> init();
  Future<void> write(String key, dynamic value);
  T? read<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
  bool containsKey(String key);
}

abstract class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

abstract class PreferencesService {
  Future<void> init();
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setInt(String key, int value);
  int? getInt(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}
