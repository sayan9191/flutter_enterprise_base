import 'package:local_auth/local_auth.dart';

import '../logger/app_logger.dart';

/// Security hooks: biometrics and device integrity checks.
class SecurityService {
  SecurityService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final _localAuth = LocalAuthentication();

  Future<void> initialize() async {
    _logger.info('SecurityService initialized');
  }

  Future<bool> canUseBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      _logger.error('Biometric check failed', e);
      return false;
    }
  }

  Future<bool> authenticate({String reason = 'Authenticate to continue'}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(biometricOnly: false),
      );
    } catch (e) {
      _logger.error('Authentication failed', e);
      return false;
    }
  }
}
