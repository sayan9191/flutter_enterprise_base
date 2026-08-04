import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../config/env/environment_manager.dart';
import '../config/router/app_router.dart';
import '../config/theme/app_theme_config.dart';
import '../config/router/auth_guard.dart';
import '../core/di/injection.dart';
import '../core/services/locale_manager.dart';
import '../core/services/navigation_service.dart';
import '../core/services/theme_manager.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = getIt<NavigationService>();
    final router = createAppRouter(
      navigationService: _navigationService,
      authGuard: getIt<AuthGuard>(),
    );
    _navigationService.setRouter(router);
  }

  @override
  Widget build(BuildContext context) {
    final env = EnvironmentManager.instance.environment;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<SettingsBloc>()),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([getIt<ThemeManager>(), getIt<LocaleManager>()]),
        builder: (context, _) {
          final themeManager = getIt<ThemeManager>();
          final localeManager = getIt<LocaleManager>();
          return MaterialApp.router(
            title: env.appName,
            debugShowCheckedModeBanner: false,
            theme: AppThemeConfig.lightTheme,
            darkTheme: AppThemeConfig.darkTheme,
            themeMode: themeManager.themeMode,
            locale: localeManager.locale,
            supportedLocales: LocaleManager.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _navigationService.router,
          );
        },
      ),
    );
  }
}
