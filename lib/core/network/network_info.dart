import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Abstraction over connectivity checking for offline-first repositories.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Default implementation using connectivity_plus and internet checker.
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({
    Connectivity? connectivity,
    InternetConnection? internetConnection,
  })  : _connectivity = connectivity ?? Connectivity(),
        _internetConnection =
            internetConnection ?? InternetConnection.createInstance();

  final Connectivity _connectivity;
  final InternetConnection _internetConnection;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) return false;
    return _internetConnection.hasInternetAccess;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((_) async {
      return isConnected;
    });
  }
}
