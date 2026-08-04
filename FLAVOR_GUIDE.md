# Flavor Guide

## Overview

Four build flavors support different environments with separate configurations.

| Flavor | Entry Point | App Name | Logging | Analytics |
|--------|-------------|----------|---------|-----------|
| Development | `main_dev.dart` | BaseStructure Dev | Yes | No |
| QA | `main_qa.dart` | BaseStructure QA | Yes | No |
| Staging | `main_stage.dart` | BaseStructure Staging | Yes | Yes |
| Production | `main_prod.dart` | BaseStructure | No | Yes |

## Entry Points

Each flavor has its own `main` file:

```dart
// lib/main_dev.dart
Future<void> main() async {
  await initializeApp(flavor: AppFlavor.dev);
  runApp(const App());
}
```

## Flavor Configuration

`lib/config/flavors/flavor_config.dart`:

```dart
enum AppFlavor { dev, qa, stage, prod }

class FlavorConfig {
  static AppFlavor get current => _current;
  static String get envFile => switch (current) {
    AppFlavor.dev => 'env/.env.dev',
    AppFlavor.qa => 'env/.env.qa',
    AppFlavor.stage => 'env/.env.stage',
    AppFlavor.prod => 'env/.env.prod',
  };
}
```

## Running Flavors

```bash
flutter run -t lib/main_dev.dart
flutter run -t lib/main_qa.dart
flutter run -t lib/main_stage.dart
flutter run -t lib/main_prod.dart
```

## Building

```bash
flutter build apk -t lib/main_prod.dart --release
flutter build appbundle -t lib/main_prod.dart --release
flutter build ios -t lib/main_prod.dart --release
```

## Android Flavor Setup (Optional)

For separate bundle IDs per flavor, configure in `android/app/build.gradle.kts`:

```kotlin
flavorDimensions += "environment"
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        resValue("string", "app_name", "BaseStructure Dev")
    }
    create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "BaseStructure")
    }
}
```

## iOS Schemes (Optional)

Create Xcode schemes for each flavor with different:
- Bundle identifier
- Display name
- Firebase config (GoogleService-Info.plist)

## Firebase Per Flavor

Place flavor-specific configs:
```
android/app/src/dev/google-services.json
android/app/src/prod/google-services.json
ios/Runner/Firebase/dev/GoogleService-Info.plist
ios/Runner/Firebase/prod/GoogleService-Info.plist
```

## Icons Per Flavor

Use flutter_launcher_icons with flavor-specific config or separate asset folders.
