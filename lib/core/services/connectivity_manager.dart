import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../logger/app_logger.dart';
import '../network/network_info.dart';

/// Monitors connectivity changes and exposes stream for UI.
class ConnectivityManager {
  ConnectivityManager({
    required NetworkInfo networkInfo,
    required AppLogger logger,
  })  : _networkInfo = networkInfo,
        _logger = logger;

  final NetworkInfo _networkInfo;
  final AppLogger _logger;
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;

  Stream<bool> get onConnectivityChanged => _controller.stream;
  bool get isConnected => _isConnected;

  Future<void> init() async {
    _isConnected = await _networkInfo.isConnected;
    _subscription = Connectivity().onConnectivityChanged.listen((results) async {
      final connected = await InternetConnection().hasInternetAccess;
      if (connected != _isConnected) {
        _isConnected = connected;
        _logger.info('Connectivity changed: $_isConnected');
        _controller.add(_isConnected);
      }
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
