import '../logger/app_logger.dart';

/// Analytics abstraction with Firebase-ready hooks.
class AnalyticsService {
  AnalyticsService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  bool _initialized = false;

  Future<void> initialize() async {
    _initialized = true;
    _logger.info('AnalyticsService initialized');
  }

  void logEvent(String name, {Map<String, Object?>? parameters}) {
    if (!_initialized) return;
    _logger.info('Analytics event: $name', parameters);
  }

  void setUserId(String? userId) {
    if (!_initialized) return;
    _logger.info('Analytics userId: $userId');
  }

  void logScreenView(String screenName) {
    logEvent('screen_view', parameters: {'screen_name': screenName});
  }
}
