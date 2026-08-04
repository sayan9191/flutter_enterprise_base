import 'package:flutter/widgets.dart';

import '../logger/app_logger.dart';
import 'session_manager.dart';

/// Tracks app lifecycle and session activity.
class AppLifecycleManager extends WidgetsBindingObserver {
  AppLifecycleManager({
    required SessionManager sessionManager,
    required AppLogger logger,
  })  : _sessionManager = sessionManager,
        _logger = logger;

  final SessionManager _sessionManager;
  final AppLogger _logger;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.info('App lifecycle: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        _sessionManager.touchSession();
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
