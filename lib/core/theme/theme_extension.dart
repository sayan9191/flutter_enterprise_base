import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Custom theme extension for design tokens accessible via Theme.of(context).
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardBackground,
    required this.borderColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
  });

  final Color cardBackground;
  final Color borderColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  static const light = AppThemeExtension(
    cardBackground: AppColors.surface,
    borderColor: AppColors.border,
    successColor: AppColors.success,
    warningColor: AppColors.warning,
    errorColor: AppColors.error,
  );

  static const dark = AppThemeExtension(
    cardBackground: AppColors.surfaceDark,
    borderColor: Color(0xFF334155),
    successColor: AppColors.success,
    warningColor: AppColors.warning,
    errorColor: AppColors.error,
  );

  @override
  AppThemeExtension copyWith({
    Color? cardBackground,
    Color? borderColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
  }) {
    return AppThemeExtension(
      cardBackground: cardBackground ?? this.cardBackground,
      borderColor: borderColor ?? this.borderColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
    );
  }
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.light;

  double get spacingSm => AppSpacing.sm;
  double get spacingMd => AppSpacing.md;
  double get spacingLg => AppSpacing.lg;
  BorderRadius get radiusMd => AppRadius.mdAll;
}
