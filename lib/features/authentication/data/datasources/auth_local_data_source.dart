import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/storage_contracts.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<void> setRememberMe(bool value);
  bool getRememberMe();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required SecureStorageService secureStorage, required PreferencesService preferences})
      : _secureStorage = secureStorage, _preferences = preferences;
  final SecureStorageService _secureStorage;
  final PreferencesService _preferences;

  @override
  Future<void> cacheUser(UserModel user) async {
    await _secureStorage.write(StorageKeys.userId, user.id);
    await _secureStorage.write(StorageKeys.userEmail, user.email);
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.delete(StorageKeys.userId);
    await _secureStorage.delete(StorageKeys.userEmail);
  }

  @override
  Future<void> setRememberMe(bool value) => _preferences.setBool(StorageKeys.rememberMe, value);

  @override
  bool getRememberMe() => _preferences.getBool(StorageKeys.rememberMe) ?? false;
}
