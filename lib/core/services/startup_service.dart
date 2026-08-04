import '../analytics/analytics_service.dart';
import '../../config/env/environment_manager.dart';
import '../logger/app_logger.dart';
import '../permissions/permission_manager.dart';
import '../security/security_service.dart';
import '../storage/hive_storage_service.dart';
import '../storage/storage_contracts.dart';
import 'connectivity_manager.dart';
import 'locale_manager.dart';
import 'theme_manager.dart';

/// Orchestrates app startup initialization sequence.
class StartupService {
  StartupService({
    required EnvironmentManager environmentManager,
    required HiveStorageService hiveStorage,
    required PreferencesService preferences,
    required ThemeManager themeManager,
    required LocaleManager localeManager,
    required ConnectivityManager connectivityManager,
    required SecurityService securityService,
    required PermissionManager permissionManager,
    required AnalyticsService analyticsService,
    required AppLogger logger,
  })  : _environmentManager = environmentManager,
        _hiveStorage = hiveStorage,
        _preferences = preferences,
        _themeManager = themeManager,
        _localeManager = localeManager,
        _connectivityManager = connectivityManager,
        _securityService = securityService,
        _permissionManager = permissionManager,
        _analyticsService = analyticsService,
        _logger = logger;

  final EnvironmentManager _environmentManager;
  final HiveStorageService _hiveStorage;
  final PreferencesService _preferences;
  final ThemeManager _themeManager;
  final LocaleManager _localeManager;
  final ConnectivityManager _connectivityManager;
  final SecurityService _securityService;
  final PermissionManager _permissionManager;
  final AnalyticsService _analyticsService;
  final AppLogger _logger;

  Future<void> initialize({required String envFile}) async {
    _logger.info('Starting app initialization...');
    await _environmentManager.load(envFile: envFile);
    await _hiveStorage.init();
    await _preferences.init();
    await _themeManager.init();
    await _localeManager.init();
    await _connectivityManager.init();
    await _securityService.initialize();
    await _permissionManager.initialize();
    if (_environmentManager.environment.enableAnalytics) {
      await _analyticsService.initialize();
    }
    _logger.info('App initialization complete');
  }
}
