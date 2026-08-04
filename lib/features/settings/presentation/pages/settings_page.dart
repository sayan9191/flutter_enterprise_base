import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_constants.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/locale_manager.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => ListView(
          children: [
            ListTile(title: Text(context.l10n.theme), subtitle: Text(state.themeMode.name)),
            RadioListTile<ThemeMode>(
              title: Text(context.l10n.lightMode),
              value: ThemeMode.light,
              groupValue: state.themeMode,
              onChanged: (v) => context.read<SettingsBloc>().add(SettingsThemeChanged(v!)),
            ),
            RadioListTile<ThemeMode>(
              title: Text(context.l10n.darkMode),
              value: ThemeMode.dark,
              groupValue: state.themeMode,
              onChanged: (v) => context.read<SettingsBloc>().add(SettingsThemeChanged(v!)),
            ),
            RadioListTile<ThemeMode>(
              title: Text(context.l10n.systemDefault),
              value: ThemeMode.system,
              groupValue: state.themeMode,
              onChanged: (v) => context.read<SettingsBloc>().add(SettingsThemeChanged(v!)),
            ),
            ListTile(title: Text(context.l10n.language)),
            ...LocaleManager.supportedLocales.map((l) => RadioListTile<Locale>(
                  title: Text(l.languageCode.toUpperCase()),
                  value: l,
                  groupValue: state.locale,
                  onChanged: (v) => context.read<SettingsBloc>().add(SettingsLocaleChanged(v!)),
                )),
            ListTile(title: Text(context.l10n.about), subtitle: const Text('Base Structure v1.0.0')),
            ListTile(
              title: Text(context.l10n.logout, style: const TextStyle(color: Colors.red)),
              onTap: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
                context.go(RouteConstants.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
