# Security Guide

## Token Storage

Access and refresh tokens stored in `FlutterSecureStorage`:
- Android: Encrypted SharedPreferences
- iOS: Keychain with first unlock accessibility

Never store tokens in SharedPreferences or Hive.

## SSL Pinning

Enable in production environment:

```
SSL_PINNING_ENABLED=true
```

Implement certificate validation in `SslPinningConfig`:

```dart
client.badCertificateCallback = (cert, host, port) {
  final fingerprint = sha256.convert(cert.der).toString();
  return trustedFingerprints.contains(fingerprint);
};
```

## Code Obfuscation

Build with obfuscation for release:

```bash
flutter build apk -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
```

Store `build/debug-info/` for crash symbolication — never commit to repo.

## Jailbreak / Root Detection

Hook in `SecurityService`:

```dart
Future<bool> isDeviceCompromised() async {
  // Integrate flutter_jailbreak_detection or freeRASP
  return false; // Replace with actual check
}
```

Call on app startup; warn or block based on policy.

## Screen Recording / Screenshot

Hook in `SecurityService` for sensitive screens:

```dart
void enableScreenProtection() {
  // Integrate screen_protector or FLAG_SECURE on Android
}
```

## Biometric Authentication

Available via `local_auth` through `SecurityService`:

```dart
final canAuth = await securityService.canAuthenticateWithBiometrics();
if (canAuth) {
  final success = await securityService.authenticateWithBiometrics(
    reason: 'Verify identity to continue',
  );
}
```

## Session Timeout

Default: 30 minutes (`AppConstants.sessionTimeoutMinutes`).

`SessionManager` tracks last active timestamp and forces re-auth on expiry.

## Device Information

`DeviceHelper` provides device ID, OS version, model for audit logging. Do not use as sole authentication factor.

## Best Practices

1. Never log tokens or passwords
2. Disable logging in production (`ENABLE_LOGGING=false`)
3. Use certificate pinning in staging and production
4. Obfuscate release builds
5. Validate all user input in domain layer
6. Use parameterized API calls (no string interpolation in URLs)
7. Clear all data on logout
8. Implement certificate transparency monitoring for production APIs
