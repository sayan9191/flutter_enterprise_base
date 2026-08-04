import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_icons.dart';

/// Bottom navigation shell — Home and Profile only (starter template).
class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.home),
            label: context.l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.profile),
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
}
