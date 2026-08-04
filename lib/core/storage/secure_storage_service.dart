import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import 'storage_contracts.dart';

/// Secure token storage using platform keychain/keystore.
class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Future<void> write(String key, String value) async {
    _logger.storage('WRITE_SECURE', key);
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    _logger.storage('READ_SECURE', key);
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    _logger.storage('DELETE_SECURE', key);
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    _logger.storage('CLEAR_SECURE', 'all');
    await _storage.deleteAll();
  }
}

/// Extension for auth token convenience methods.
extension SecureStorageAuth on SecureStorageService {
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await write(StorageKeys.accessToken, accessToken);
    if (refreshToken != null) {
      await write(StorageKeys.refreshToken, refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }
}
