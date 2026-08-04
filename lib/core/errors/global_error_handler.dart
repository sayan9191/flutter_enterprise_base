import 'package:flutter/foundation.dart';

import '../failure/failure.dart';
import '../logger/app_logger.dart';
import 'error_mapper.dart';

/// Global error handler with crash reporting hook for production.
class GlobalErrorHandler {
  GlobalErrorHandler({
    required AppLogger logger,
    ErrorMapper? errorMapper,
  })  : _logger = logger,
        _errorMapper = errorMapper ?? const ErrorMapper();

  final AppLogger _logger;
  final ErrorMapper _errorMapper;

  void initialize() {
    FlutterError.onError = (details) {
      _logger.error('FlutterError', details.exception, details.stack);
      _reportCrash(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.error('PlatformError', error, stack);
      _reportCrash(error, stack);
      return true;
    };
  }

  Failure handle(Object error, [StackTrace? stackTrace]) {
    _logger.error('Handled error', error, stackTrace);
    return _errorMapper.mapException(error);
  }

  /// Hook for Firebase Crashlytics / Sentry integration.
  void _reportCrash(Object error, StackTrace? stack) {
    if (kReleaseMode) {
      // Integrate crash reporting SDK here.
    }
  }
}
