import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Theme configuration entry point for flavor-specific overrides.
abstract final class AppThemeConfig {
  static ThemeData get lightTheme => AppTheme.light;
  static ThemeData get darkTheme => AppTheme.dark;
}
