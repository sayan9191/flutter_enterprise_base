import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logger/app_logger.dart';

/// Global navigation helper wrapping GoRouter.
class NavigationService {
  NavigationService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GoRouter? _router;

  void setRouter(GoRouter router) => _router = router;

  GoRouter get router {
    assert(_router != null, 'Router not initialized');
    return _router!;
  }

  BuildContext? get context => navigatorKey.currentContext;

  void go(String location, {Object? extra}) {
    _logger.navigation(location, extra: extra);
    router.go(location, extra: extra);
  }

  void push(String location, {Object? extra}) {
    _logger.navigation(location, extra: extra);
    router.push(location, extra: extra);
  }

  void pop<T extends Object?>([T? result]) {
    _logger.navigation('pop');
    router.pop(result);
  }

  void replace(String location, {Object? extra}) {
    _logger.navigation(location, extra: extra);
    router.replace(location, extra: extra);
  }
}
