import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../core/services/navigation_service.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/otp_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/authentication/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_shell.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/bloc/search_users_bloc.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'auth_guard.dart';
import 'route_constants.dart';

GoRouter createAppRouter({required NavigationService navigationService, required AuthGuard authGuard}) {
  final rootKey = navigationService.navigatorKey;
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: RouteConstants.splash,
    redirect: (context, state) async {
      final loc = state.matchedLocation;
      final authRoutes = {RouteConstants.login, RouteConstants.register, RouteConstants.forgotPassword, RouteConstants.otp, RouteConstants.resetPassword, RouteConstants.splash, RouteConstants.onboarding};
      final isAuth = await authGuard.isAuthenticated();
      if (!isAuth && loc.startsWith('/dashboard')) return RouteConstants.login;
      if (isAuth && authRoutes.contains(loc) && loc != RouteConstants.splash) return RouteConstants.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (_, __) => BlocProvider(create: (_) => getIt<SplashBloc>(), child: const SplashPage()),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (_, __) => BlocProvider(create: (_) => getIt<OnboardingBloc>(), child: const OnboardingPage()),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (_, __) => BlocProvider.value(value: getIt<AuthBloc>(), child: const LoginPage()),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (_, __) => BlocProvider.value(value: getIt<AuthBloc>(), child: const RegisterPage()),
      ),
      GoRoute(
        path: RouteConstants.forgotPassword,
        builder: (_, __) => BlocProvider.value(value: getIt<AuthBloc>(), child: const ForgotPasswordPage()),
      ),
      GoRoute(
        path: RouteConstants.otp,
        builder: (_, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return BlocProvider.value(value: getIt<AuthBloc>(), child: OtpPage(email: email));
        },
      ),
      GoRoute(
        path: RouteConstants.resetPassword,
        builder: (_, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return BlocProvider.value(value: getIt<AuthBloc>(), child: ResetPasswordPage(email: email));
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => DashboardShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/home', builder: (_, __) => BlocProvider(create: (_) => getIt<HomeBloc>(), child: const HomePage())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/search', builder: (_, __) => BlocProvider(create: (_) => getIt<SearchUsersBloc>(), child: const SearchPage())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/notifications', builder: (_, __) => const NotificationPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/profile', builder: (_, __) => BlocProvider(create: (_) => getIt<ProfileBloc>(), child: const ProfilePage())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/settings', builder: (_, __) => BlocProvider(create: (_) => getIt<SettingsBloc>(), child: const SettingsPage())),
          ]),
        ],
      ),
    ],
  );
}
