import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_icons.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: widget.navigationShell.goBranch,
        destinations: [
          NavigationDestination(icon: Icon(AppIcons.home), label: context.l10n.home),
          NavigationDestination(icon: Icon(AppIcons.search), label: context.l10n.search),
          NavigationDestination(icon: Icon(AppIcons.notifications), label: context.l10n.notifications),
          NavigationDestination(icon: Icon(AppIcons.profile), label: context.l10n.profile),
          NavigationDestination(icon: Icon(AppIcons.settings), label: context.l10n.settings),
        ],
      ),
    );
  }
}
