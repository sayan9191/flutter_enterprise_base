/// Keys for Hive boxes and SharedPreferences / SecureStorage.
abstract final class StorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const userId = 'user_id';
  static const userEmail = 'user_email';
  static const userProfile = 'user_profile';
  static const rememberMe = 'remember_me';
  static const themeMode = 'theme_mode';
  static const locale = 'locale';
  static const onboardingComplete = 'onboarding_complete';
  static const recentSearches = 'recent_searches';
  static const favorites = 'favorites';
  static const pendingSyncQueue = 'pending_sync_queue';
  static const apiCachePrefix = 'api_cache_';
  static const sessionLastActive = 'session_last_active';
}

/// Hive box names.
abstract final class HiveBoxes {
  static const user = 'user_box';
  static const settings = 'settings_box';
  static const cache = 'cache_box';
  static const syncQueue = 'sync_queue_box';
  static const search = 'search_box';
}
