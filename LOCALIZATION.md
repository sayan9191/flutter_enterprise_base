# Localization

## Setup

Uses Flutter's built-in gen-l10n with ARB files in `lib/l10n/`.

Configuration in `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

## Supported Languages

| Code | Language | File |
|------|----------|------|
| en | English | `app_en.arb` |
| hi | Hindi | `app_hi.arb` |

## Usage

```dart
// In widgets
AppLocalizations.of(context)!.login

// Via extension (if configured)
context.l10n.login
```

## Locale Manager

`LocaleManager` handles persistence and switching:

```dart
await localeManager.setLocale(const Locale('hi'));
localeManager.localeStream.listen((locale) { /* rebuild app */ });
```

Stored in SharedPreferences via `StorageKeys.locale`.

## Adding a New Language

1. Create `lib/l10n/app_<code>.arb` (copy from `app_en.arb`)
2. Translate all keys
3. Run `flutter gen-l10n`
4. Add locale to `App.supportedLocales` in `app.dart`

Example for Spanish:

```json
// app_es.arb
{
  "@@locale": "es",
  "appTitle": "Estructura Base",
  "login": "Iniciar sesión"
}
```

```dart
// app.dart
supportedLocales: const [
  Locale('en'),
  Locale('hi'),
  Locale('es'),
],
```

## ARB Key Conventions

- camelCase keys: `forgotPassword`
- Descriptions for translators: `"@forgotPassword": { "description": "..." }`
- Placeholders: `"greeting": "Hello, {name}"` with `"@greeting": { "placeholders": { "name": { "type": "String" } } }`

## Generate

```bash
flutter gen-l10n
```

Generated files appear in `lib/l10n/app_localizations*.dart` (do not edit manually).

## RTL Support

Flutter handles RTL automatically for Arabic, Hebrew, etc. Ensure layouts use `Directionality`-aware widgets.

## Settings Integration

Language picker in Settings page calls `LocaleManager.setLocale()`.
