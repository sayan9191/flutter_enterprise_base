# Project Setup

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter | 3.35+ (stable channel) |
| Dart | 3.9+ |
| Xcode | 15+ (iOS) |
| Android Studio | Latest (Android) |

Verify installation:

```bash
flutter doctor -v
```

## Initial Setup

```bash
# 1. Clone repository
git clone <repo-url> base_structure
cd base_structure

# 2. Install dependencies
flutter pub get

# 3. Generate localizations
flutter gen-l10n

# 4. Run code generation (if using json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 5. Run development flavor
flutter run -t lib/main_dev.dart
```

## Environment Files

Environment files live in `env/`:

```
env/.env.dev      # Development
env/.env.qa       # QA
env/.env.stage    # Staging
env/.env.prod     # Production
```

These are loaded at startup via `flutter_dotenv`. Never commit secrets — use CI environment variables for production keys.

## IDE Setup

### VS Code / Cursor

Recommended extensions:
- Dart
- Flutter
- Bloc

Add to `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart"
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart"
    }
  ]
}
```

## Platform Setup

### Android

Minimum SDK: 21. Update `android/app/build.gradle.kts` for flavor-specific application IDs.

### iOS

Minimum deployment target: 13.0. Configure signing in Xcode.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Missing localizations | Run `flutter gen-l10n` |
| Hive init error | Clear app data / reinstall |
| Env not loaded | Verify env file path in pubspec assets |
| DI not registered | Call `configureDependencies()` before runApp |
