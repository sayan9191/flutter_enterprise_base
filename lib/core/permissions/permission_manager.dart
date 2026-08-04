import 'package:permission_handler/permission_handler.dart';

import '../logger/app_logger.dart';

/// Centralized permission requests.
class PermissionManager {
  PermissionManager({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  Future<void> initialize() async {
    _logger.info('PermissionManager initialized');
  }

  Future<bool> requestCamera() => _request(Permission.camera);
  Future<bool> requestPhotos() => _request(Permission.photos);
  Future<bool> requestNotification() => _request(Permission.notification);

  Future<bool> _request(Permission permission) async {
    final status = await permission.request();
    _logger.info('Permission $permission: $status');
    return status.isGranted;
  }
}
