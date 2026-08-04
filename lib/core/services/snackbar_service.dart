import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Centralized snackbar presentation.
class SnackbarService {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.info);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
