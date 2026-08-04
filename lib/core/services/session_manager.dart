import '../constants/storage_keys.dart';
import '../logger/app_logger.dart';
import '../network/network.dart';
import '../storage/storage_contracts.dart';
import '../storage/secure_storage_service.dart';
import 'event_bus.dart';

/// Manages auth session lifecycle, token storage, and refresh.
class SessionManager {
  SessionManager({
    required SecureStorageService secureStorage,
    required PreferencesService preferences,
    required ApiClient Function() apiClientProvider,
    required AppLogger logger,
    required EventBus eventBus,
  })  : _secureStorage = secureStorage,
        _preferences = preferences,
        _apiClientProvider = apiClientProvider,
        _logger = logger,
        _eventBus = eventBus;

  final SecureStorageService _secureStorage;
  final PreferencesService _preferences;
  final ApiClient Function() _apiClientProvider;
  final AppLogger _logger;
  final EventBus _eventBus;

  ApiClient get _apiClient => _apiClientProvider();

  Future<bool> get isLoggedIn async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<String?> get accessToken =>
      _secureStorage.read(StorageKeys.accessToken);

  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    required String userId,
    required String email,
  }) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await _secureStorage.write(StorageKeys.userId, userId);
    await _secureStorage.write(StorageKeys.userEmail, email);
    await _preferences.setString(StorageKeys.sessionLastActive, DateTime.now().toIso8601String());
    _logger.info('Session saved for $email');
    _eventBus.fire(SessionChangedEvent(isLoggedIn: true));
  }

  Future<bool> refreshToken() async {
    final refresh = await _secureStorage.read(StorageKeys.refreshToken);
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/login',
        data: {'token': refresh},
      );
      final token = response.data?['token'] as String?;
      if (token == null) return false;
      await _secureStorage.write(StorageKeys.accessToken, token);
      _logger.info('Token refreshed');
      return true;
    } catch (e) {
      _logger.error('Token refresh failed', e);
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.clearTokens();
    await _secureStorage.delete(StorageKeys.userId);
    await _secureStorage.delete(StorageKeys.userEmail);
    await _preferences.remove(StorageKeys.rememberMe);
    _logger.info('Session cleared');
    _eventBus.fire(SessionChangedEvent(isLoggedIn: false));
  }

  Future<bool> isSessionExpired() async {
    final lastActive = _preferences.getString(StorageKeys.sessionLastActive);
    if (lastActive == null) return false;
    final last = DateTime.tryParse(lastActive);
    if (last == null) return false;
    return DateTime.now().difference(last).inMinutes > 30;
  }

  Future<void> touchSession() async {
    await _preferences.setString(
      StorageKeys.sessionLastActive,
      DateTime.now().toIso8601String(),
    );
  }
}

class SessionChangedEvent {
  const SessionChangedEvent({required this.isLoggedIn});
  final bool isLoggedIn;
}
