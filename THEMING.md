# Theming

## Design System

All design tokens live in `lib/core/theme/`:

| File | Contents |
|------|----------|
| `app_colors.dart` | Color palette (light + dark) |
| `app_typography.dart` | Text styles (Google Fonts) |
| `app_spacing.dart` | Spacing scale (4px grid) |
| `app_radius.dart` | Border radius values |
| `app_icons.dart` | Icon constants |
| `app_shadows.dart` | Box shadow definitions |
| `theme_extension.dart` | Custom ThemeExtension |
| `app_theme.dart` | Light + dark ThemeData |

## Theme Manager

`ThemeManager` persists and applies theme mode:

```dart
// Toggle theme
await themeManager.setThemeMode(ThemeMode.dark);

// Listen to changes
themeManager.themeModeStream.listen((mode) { /* rebuild */ });
```

Stored in SharedPreferences via `StorageKeys.themeMode`.

## Material 3

Both themes use Material 3:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  extensions: [AppThemeExtension.light],
)
```

## Theme Extension

Custom tokens accessible via context:

```dart
final ext = Theme.of(context).extension<AppThemeExtension>()!;
ext.cardElevation;
ext.dividerColor;
```

## Typography

Uses Google Fonts (Inter) with custom font support:

```dart
// app_typography.dart
static TextStyle get headlineLarge => GoogleFonts.inter(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);
```

Add custom fonts in `assets/fonts/` and register in `pubspec.yaml`.

## Responsive Layout

Use `context.isTablet`, `context.isDesktop` extensions:

```dart
final columns = context.isDesktop ? 4 : context.isTablet ? 2 : 1;
```

## Dark Theme

Toggle in Settings or programmatically:

```dart
themeManager.setThemeMode(ThemeMode.system); // light | dark | system
```

## Adding Custom Colors

1. Add to `AppColors`
2. Reference in `app_theme.dart` ColorScheme
3. Add to `AppThemeExtension` if needed outside ColorScheme

## Spacing Scale

```dart
AppSpacing.xs   // 4
AppSpacing.sm   // 8
AppSpacing.md   // 16
AppSpacing.lg   // 24
AppSpacing.xl   // 32
AppSpacing.xxl  // 48
```

## Custom Fonts

1. Add font files to `assets/fonts/`
2. Register in `pubspec.yaml`
3. Update `app_typography.dart` to use `FontFamily.appCustom`
