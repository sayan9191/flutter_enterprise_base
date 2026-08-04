#!/usr/bin/env python3
"""Generates remaining Flutter source files for base_structure."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "lib"

def write(rel: str, content: str) -> None:
    path = ROOT / rel
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.strip() + "\n", encoding="utf-8")
    print(f"  {rel}")

FILES = {}

# --- Extensions ---
FILES["core/extensions/string_extensions.dart"] = '''
extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[^@]+@[^@]+\\.[^@]+').hasMatch(this);
  }

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  bool get isNullOrEmpty => trim().isEmpty;
}
'''

FILES["core/extensions/context_extensions.dart"] = '''
import 'package:flutter/material.dart';

import '../theme/theme_extension.dart';
import '../../l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  AppLocalizations get l10n => AppLocalizations.of(this);
  AppThemeExtension get appThemeExt => appTheme;

  void hideKeyboard() => FocusScope.of(this).unfocus();

  Future<T?> pushPage<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
'''

FILES["core/extensions/datetime_extensions.dart"] = '''
extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String toIsoDate() => toIso8601String().split('T').first;
}
'''

FILES["core/extensions/extensions.dart"] = '''
export 'context_extensions.dart';
export 'datetime_extensions.dart';
export 'string_extensions.dart';
'''

# --- Helpers ---
FILES["core/helpers/debouncer.dart"] = '''
import 'dart:async';

import '../constants/app_constants.dart';

/// Debounces rapid callbacks (e.g. search input).
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: AppConstants.debounceMilliseconds)});

  final Duration duration;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void cancel() => _timer?.cancel();

  void dispose() => _timer?.cancel();
}
'''

FILES["core/helpers/throttle.dart"] = '''
import 'dart:async';

/// Throttles callbacks to at most once per [duration].
class Throttle {
  Throttle({this.duration = const Duration(milliseconds: 300)});

  final Duration duration;
  Timer? _timer;
  bool _isReady = true;

  void run(void Function() action) {
    if (!_isReady) return;
    _isReady = false;
    action();
    _timer?.cancel();
    _timer = Timer(duration, () => _isReady = true);
  }

  void dispose() {
    _timer?.cancel();
    _isReady = true;
  }
}
'''

# --- Utils ---
FILES["core/utils/date_formatter.dart"] = '''
import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static String formatDate(DateTime date, {String pattern = 'MMM d, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(date);
  }
}
'''

FILES["core/utils/device_helper.dart"] = '''
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract final class DeviceHelper {
  static Future<String> get deviceName async {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return '${android.manufacturer} ${android.model}';
    }
    if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return ios.utsname.machine;
    }
    return 'Unknown';
  }

  static Future<String> get appVersion async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  }

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}
'''

FILES["core/utils/formatters.dart"] = '''
import 'package:intl/intl.dart';

abstract final class Formatters {
  static final currency = NumberFormat.currency(symbol: '\\$');
  static final compact = NumberFormat.compact();

  static String phone(String value) {
    final digits = value.replaceAll(RegExp(r'\\D'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return value;
  }
}
'''

# --- Validators ---
FILES["core/validators/validators.dart"] = '''
import '../extensions/string_extensions.dart';

abstract final class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.isValidEmail) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != length || int.tryParse(value) == null) {
      return 'Enter a valid $length-digit OTP';
    }
    return null;
  }
}
'''

# --- Permissions ---
FILES["core/permissions/permission_manager.dart"] = '''
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
'''

# --- Security ---
FILES["core/security/security_service.dart"] = '''
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
'''

# --- Analytics ---
FILES["core/analytics/analytics_service.dart"] = '''
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
'''

print("Generating core support files...")
for rel, content in FILES.items():
    write(rel, content)

print("Done.")
