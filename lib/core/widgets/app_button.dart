import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: AppSpacing.sm)],
              Text(label),
            ],
          );

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.secondary => FilledButton.tonal(onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.outline => OutlinedButton(onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.text => TextButton(onPressed: isLoading ? null : onPressed, child: child),
    };
  }
}
