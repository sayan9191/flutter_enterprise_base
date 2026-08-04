# Environment Guide

## Environment Files

Located in `env/` directory:

```
env/.env.dev      # Development
env/.env.qa       # QA
env/.env.stage    # Staging
env/.env.prod     # Production
```

## Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `APP_NAME` | Display name | BaseStructure Dev |
| `APP_ENV` | Environment identifier | development |
| `BASE_URL` | API base URL | https://reqres.in/api |
| `API_TIMEOUT` | Request timeout (ms) | 30000 |
| `ENABLE_LOGGING` | Debug logging | true |
| `ENABLE_ANALYTICS` | Analytics collection | false |
| `ENABLE_CRASHLYTICS` | Crash reporting | false |
| `SSL_PINNING_ENABLED` | Certificate pinning | false |
| `FEATURE_BIOMETRIC` | Biometric auth | true |
| `FEATURE_OFFLINE_MODE` | Offline caching | true |

## Loading

Environment loaded at startup in `AppInitializer`:

```dart
await EnvironmentManager.instance.load(envFile: FlavorConfig.envFile);
final env = EnvironmentManager.instance.environment;
```

Uses `flutter_dotenv` — files must be listed in `pubspec.yaml` assets.

## Environment Class

```dart
final env = EnvironmentManager.instance.environment;
print(env.baseUrl);        // API URL
print(env.isProduction);   // bool
print(env.enableLogging);  // bool
```

## Feature Flags

```dart
final flags = EnvironmentManager.instance.featureFlags;
if (flags.biometric) { /* show biometric login */ }
if (flags.offlineMode) { /* enable caching */ }
```

## Security Notes

1. **Never commit production secrets** — use CI environment variables
2. `.env.prod` should contain non-sensitive defaults only
3. API keys injected via CI/CD secrets at build time
4. Add `env/.env.local` to `.gitignore` for developer overrides

## CI/CD Integration

```yaml
# GitHub Actions
- name: Create production env
  run: |
    echo "BASE_URL=${{ secrets.API_BASE_URL }}" >> env/.env.prod
    echo "API_KEY=${{ secrets.API_KEY }}" >> env/.env.prod
```

## Adding New Variables

1. Add to all `.env.*` files
2. Add field to `Environment` class
3. Parse in `EnvironmentLoader.fromDotEnv()`
4. Use via `EnvironmentManager.instance.environment`

## Runtime Override (Debug Only)

```dart
// For testing different endpoints without rebuild
if (kDebugMode) {
  // Override via debug menu or flutter driver
}
```
