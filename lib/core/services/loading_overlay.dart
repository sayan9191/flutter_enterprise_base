import 'package:flutter/material.dart';

import '../widgets/app_loading_indicator.dart';

/// Global loading overlay widget.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.isVisible = false,
    this.child,
  });

  final String? message;
  final bool isVisible;
  final Widget? child;

  static OverlayEntry? _entry;

  static void show(BuildContext context, {String? message}) {
    hide();
    _entry = OverlayEntry(
      builder: (_) => LoadingOverlay(message: message, isVisible: true),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    if (child != null && !isVisible) return child!;

    return Stack(
      children: [
        if (child != null) child!,
        if (isVisible)
          ColoredBox(
            color: Colors.black45,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLoadingIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
