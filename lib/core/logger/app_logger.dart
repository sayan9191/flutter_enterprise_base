import 'package:flutter/foundation.dart';

/// Structured logger that is disabled in release builds by default.
class AppLogger {
  AppLogger({required this.enabled});

  final bool enabled;

  void debug(String message, [Object? data]) {
    if (enabled) debugPrint('[DEBUG] $message ${data ?? ''}');
  }

  void info(String message, [Object? data]) {
    if (enabled) debugPrint('[INFO] $message ${data ?? ''}');
  }

  void warning(String message, [Object? data]) {
    if (enabled) debugPrint('[WARN] $message ${data ?? ''}');
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (enabled) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint(error.toString());
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }

  void api(String method, String url, {Object? body, Object? response}) {
    if (enabled) {
      debugPrint('[API] $method $url');
      if (body != null) debugPrint('Body: $body');
      if (response != null) debugPrint('Response: $response');
    }
  }

  void bloc(String bloc, String event, [Object? state]) {
    if (enabled) debugPrint('[BLOC] $bloc -> $event ${state ?? ''}');
  }

  void navigation(String route, {Object? extra}) {
    if (enabled) debugPrint('[NAV] $route ${extra ?? ''}');
  }

  void storage(String action, String key, [Object? value]) {
    if (enabled) debugPrint('[STORAGE] $action $key ${value ?? ''}');
  }
}
