# Navigation

## Router

Navigation uses **GoRouter** configured in `lib/config/router/app_router.dart`.

## Route Constants

All paths defined in `route_constants.dart`:

```dart
abstract final class RouteConstants {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const otp = '/otp';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const home = '/dashboard/home';
  static const search = '/dashboard/search';
  static const notifications = '/dashboard/notifications';
  static const profile = '/dashboard/profile';
  static const settings = '/settings';
}
```

## Shell Route (Bottom Navigation)

Dashboard uses `StatefulShellRoute` to maintain tab state:

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return DashboardShell(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(routes: [/* Home */]),
    StatefulShellBranch(routes: [/* Search */]),
    StatefulShellBranch(routes: [/* Notifications */]),
    StatefulShellBranch(routes: [/* Profile */]),
  ],
)
```

Each tab maintains its own navigation stack.

## Auth Guard

Redirect logic prevents unauthenticated access:

- Unauthenticated + protected route → Login
- Authenticated + auth route → Dashboard

## Deep Linking

GoRouter supports deep links out of the box:

```
myapp://dashboard/home
myapp://login
```

Configure in:
- Android: `AndroidManifest.xml` intent filters
- iOS: `Info.plist` URL schemes

## Navigation Service

Programmatic navigation via `NavigationService`:

```dart
getIt<NavigationService>().go(RouteConstants.settings);
getIt<NavigationService>().push('/profile/edit');
getIt<NavigationService>().pop();
getIt<NavigationService>().goNamed('login');
```

## Passing Arguments

```dart
// Define route with extra
GoRoute(
  path: '/user/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    final extra = state.extra as User?;
    return UserDetailPage(userId: id, user: extra);
  },
)

// Navigate with arguments
context.push('/user/123', extra: userEntity);
```

## Navigation Logging

All navigation logged via `AppLogger.navigation()` in debug mode.

## Adding a New Route

1. Add constant to `RouteConstants`
2. Add `GoRoute` in `app_router.dart`
3. Register BLoC provider if needed
4. Update auth guard if protected

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md#add-routes).
