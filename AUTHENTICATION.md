# Authentication

## Flow Overview

```
Splash → Check Session → Onboarding (first launch) → Login → Dashboard
                              ↓
                     Auto Login (remember me)
```

## Screens

| Screen | Route | Purpose |
|--------|-------|---------|
| Splash | `/` | Session check, app init |
| Onboarding | `/onboarding` | First-launch carousel |
| Login | `/login` | Email/password auth |
| Register | `/register` | New account creation |
| Forgot Password | `/forgot-password` | Password reset request |
| OTP | `/otp` | OTP verification |
| Reset Password | `/reset-password` | New password entry |
| Dashboard | `/dashboard` | Authenticated shell |

## JWT Token Management

### Storage

Tokens stored in `FlutterSecureStorage` (encrypted):

```dart
await secureStorage.saveTokens(
  accessToken: response.token,
  refreshToken: response.refreshToken,
);
```

### Session Manager

`SessionManager` handles:
- Auto login on app start
- Token refresh on 401
- Session timeout (30 min default)
- Logout (clear tokens + redirect)

### Auto Login

On splash, `SessionManager.isAuthenticated()` checks:
1. Access token exists in secure storage
2. Session not expired (last active timestamp)
3. Remember me flag (optional)

## Auth Guard

GoRouter redirect in `auth_guard.dart`:

```dart
redirect: (context, state) {
  final isLoggedIn = sessionManager.isAuthenticated;
  final isAuthRoute = state.matchedLocation.startsWith('/login');
  
  if (!isLoggedIn && !isAuthRoute) return RouteConstants.login;
  if (isLoggedIn && isAuthRoute) return RouteConstants.dashboard;
  return null;
}
```

## ReqRes Login

```dart
POST /api/login
Body: { "email": "eve.holt@reqres.in", "password": "cityslicka" }
Response: { "token": "QpwL5tke4Pnpja7X4" }
```

## Remember Me

Stored in SharedPreferences:

```dart
await preferences.setBool(StorageKeys.rememberMe, true);
```

When enabled, session persists across app restarts.

## Logout Flow

1. Clear secure tokens
2. Clear user cache in Hive
3. Reset session timestamp
4. Navigate to login via `NavigationService`
5. Emit logout event on `EventBus`

## Session Expiry

`AppLifecycleManager` updates `sessionLastActive` on resume.
`SessionManager` checks timeout on each authenticated request.

## Biometric Authentication

Hook available in `SecurityService`:

```dart
final authenticated = await securityService.authenticateWithBiometrics(
  reason: 'Verify your identity',
);
```

Enable via feature flag: `FEATURE_BIOMETRIC=true`.

## Feature Structure

```
features/authentication/
├── data/
│   ├── datasources/
│   │   ├── local/auth_local_data_source.dart
│   │   └── remote/auth_remote_data_source.dart
│   ├── models/auth_response_model.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/login, register, logout, etc.
└── presentation/
    ├── bloc/auth_bloc.dart
    └── pages/login, register, etc.
```
