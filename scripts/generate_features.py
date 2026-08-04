#!/usr/bin/env python3
"""Generates widgets, features, app, config, DI, main, and test files."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "lib"
TEST = Path(__file__).resolve().parent.parent / "test"

def write(rel: str, content: str, base: Path = ROOT) -> None:
    path = base / rel
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.strip() + "\n", encoding="utf-8")
    print(f"  {rel}")

# Widget files
widgets = {
"core/widgets/app_loading_indicator.dart": '''
import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.size = 32, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
''',
"core/widgets/app_button.dart": '''
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
''',
"core/widgets/app_text_field.dart": '''
import 'package:flutter/material.dart';

import '../theme/app_icons.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscure ? AppIcons.visibilityOff : AppIcons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
''',
"core/widgets/app_empty_state.dart": '''
import 'package:flutter/material.dart';

import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.icon = AppIcons.empty,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: AppSpacing.lg),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
''',
"core/widgets/app_error_view.dart": '''
import 'package:flutter/material.dart';

import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(AppIcons.error, size: 48, color: Colors.red),
          const SizedBox(height: AppSpacing.md),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
''',
"core/widgets/app_network_image.dart": '''
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: AppColors.shimmerBase, width: width, height: height),
      ),
      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
''',
"core/widgets/app_scaffold.dart": '''
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
  });

  final String? title;
  final Widget? body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(title: Text(title!), actions: actions)
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
    );
  }
}
''',
"core/widgets/app_card.dart": '''
import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_extension.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appTheme.cardBackground,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
''',
"core/widgets/app_divider.dart": '''
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.height = 1});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, thickness: height);
  }
}
''',
"core/widgets/app_avatar.dart": '''
import 'package:flutter/material.dart';

import 'app_network_image.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.imageUrl, this.name, this.radius = 24});

  final String? imageUrl;
  final String? name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ClipOval(
          child: AppNetworkImage(url: imageUrl!, width: radius * 2, height: radius * 2),
        ),
      );
    }
    final initial = (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(initial, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
    );
  }
}
''',
"core/widgets/app_badge.dart": '''
import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: child,
    );
  }
}
''',
"core/widgets/app_chip.dart": '''
import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, this.onDeleted, this.selected = false});

  final String label;
  final VoidCallback? onDeleted;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
      onDeleted: onDeleted,
    );
  }
}
''',
"core/widgets/app_search_bar.dart": '''
import 'package:flutter/material.dart';

import '../theme/app_icons.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(AppIcons.search),
        suffixIcon: onClear != null
            ? IconButton(icon: const Icon(AppIcons.close), onPressed: onClear)
            : null,
      ),
    );
  }
}
''',
"core/widgets/app_bottom_sheet.dart": '''
import 'package:flutter/material.dart';

abstract final class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: child,
      ),
    );
  }
}
''',
"core/widgets/app_dialog.dart": '''
import 'package:flutter/material.dart';

abstract final class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => AlertDialog(title: Text(title), content: content, actions: actions),
    );
  }
}
''',
"core/widgets/app_refresh_indicator.dart": '''
import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}
''',
"core/widgets/widgets.dart": '''
export 'app_avatar.dart';
export 'app_badge.dart';
export 'app_bottom_sheet.dart';
export 'app_button.dart';
export 'app_card.dart';
export 'app_chip.dart';
export 'app_dialog.dart';
export 'app_divider.dart';
export 'app_empty_state.dart';
export 'app_error_view.dart';
export 'app_loading_indicator.dart';
export 'app_network_image.dart';
export 'app_refresh_indicator.dart';
export 'app_scaffold.dart';
export 'app_search_bar.dart';
export 'app_text_field.dart';
''',
}

print("Generating widgets...")
for rel, content in widgets.items():
    write(rel, content)

print("Done widgets.")
