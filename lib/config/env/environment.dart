/// Application environment loaded from .env files per flavor.
class Environment {
  const Environment({
    required this.appName,
    required this.env,
    required this.baseUrl,
    required this.apiTimeout,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableCrashlytics,
    required this.sslPinningEnabled,
    required this.featureBiometric,
    required this.featureOfflineMode,
  });

  final String appName;
  final String env;
  final String baseUrl;
  final int apiTimeout;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableCrashlytics;
  final bool sslPinningEnabled;
  final bool featureBiometric;
  final bool featureOfflineMode;

  bool get isProduction => env == 'production';
  bool get isDevelopment => env == 'development';
}

/// Loads and parses environment variables from dotenv.
class EnvironmentLoader {
  static Environment fromDotEnv(Map<String, String> env) {
    return Environment(
      appName: env['APP_NAME'] ?? 'Base Structure',
      env: env['APP_ENV'] ?? 'development',
      baseUrl: env['BASE_URL'] ?? 'https://reqres.in/api',
      apiTimeout: int.tryParse(env['API_TIMEOUT'] ?? '30000') ?? 30000,
      enableLogging: env['ENABLE_LOGGING'] == 'true',
      enableAnalytics: env['ENABLE_ANALYTICS'] == 'true',
      enableCrashlytics: env['ENABLE_CRASHLYTICS'] == 'true',
      sslPinningEnabled: env['SSL_PINNING_ENABLED'] == 'true',
      featureBiometric: env['FEATURE_BIOMETRIC'] == 'true',
      featureOfflineMode: env['FEATURE_OFFLINE_MODE'] == 'true',
    );
  }
}

/// Feature flags derived from environment configuration.
class FeatureFlags {
  FeatureFlags({required this.environment});

  final Environment environment;

  bool get biometric => environment.featureBiometric;
  bool get offlineMode => environment.featureOfflineMode;
  bool get analytics => environment.enableAnalytics;
  bool get crashlytics => environment.enableCrashlytics;
}
