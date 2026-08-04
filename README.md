# Base Structure — Enterprise Flutter Starter Template

Production-ready Flutter starter template built for enterprise applications. Designed as the foundation for all future commercial Flutter projects at scale.

## Highlights

- **Clean Architecture** — Feature-first modules with data/domain/presentation layers
- **BLoC State Management** — BaseBloc, PaginationBloc, SearchBloc with generic ViewStatus
- **Offline First** — Hive caching, sync queue, connectivity-aware repositories
- **Security** — Secure token storage, biometric hooks, SSL pinning ready
- **Multi-Flavor** — Dev, QA, Staging, Production with separate env files
- **Material 3** — Light/dark themes, responsive layout, tablet/desktop ready
- **Localization** — English + Hindi with easy extension
- **Testing** — Unit, widget, bloc tests with mocktail
- **CI/CD** — GitHub Actions, Codemagic, Fastlane ready

## Quick Start

```bash
# Clone and install
git clone <repo-url>
cd base_structure
flutter pub get
flutter gen-l10n

# Run development flavor
flutter run -t lib/main_dev.dart

# Run tests
flutter test

# Analyze
flutter analyze
```

### Test Credentials (ReqRes API)

| Email | Password |
|-------|----------|
| `eve.holt@reqres.in` | `cityslicka` |
| `peter@klaven.fi` | (any for register demo) |

## Project Structure

```
lib/
├── app/           # Bootstrap, observer, initializer
├── config/        # Env, theme, router, flavors
├── core/          # Shared infrastructure
├── features/      # Feature modules (Clean Architecture)
├── l10n/          # Localization
└── main_*.dart    # Flavor entry points
```

## Documentation

| Guide | Description |
|-------|-------------|
| [PROJECT_SETUP.md](PROJECT_SETUP.md) | Initial setup and prerequisites |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Clean Architecture overview |
| [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) | Directory layout reference |
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | How to add features, blocs, APIs |
| [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md) | BLoC patterns and ViewStatus |
| [NETWORKING.md](NETWORKING.md) | Dio, interceptors, error handling |
| [OFFLINE_SUPPORT.md](OFFLINE_SUPPORT.md) | Caching and sync strategies |
| [AUTHENTICATION.md](AUTHENTICATION.md) | JWT flow, session management |
| [NAVIGATION.md](NAVIGATION.md) | GoRouter, guards, deep links |
| [THEMING.md](THEMING.md) | Design tokens and theme manager |
| [LOCALIZATION.md](LOCALIZATION.md) | i18n setup and new languages |
| [FLAVOR_GUIDE.md](FLAVOR_GUIDE.md) | Build flavors configuration |
| [ENVIRONMENT_GUIDE.md](ENVIRONMENT_GUIDE.md) | .env files and feature flags |
| [API_GUIDE.md](API_GUIDE.md) | ReqRes API integration |
| [TESTING_GUIDE.md](TESTING_GUIDE.md) | Test setup and patterns |
| [CODING_GUIDELINES.md](CODING_GUIDELINES.md) | Code standards |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution workflow |

## Flavors

| Flavor | Entry Point | Env File |
|--------|-------------|----------|
| Development | `lib/main_dev.dart` | `env/.env.dev` |
| QA | `lib/main_qa.dart` | `env/.env.qa` |
| Staging | `lib/main_stage.dart` | `env/.env.stage` |
| Production | `lib/main_prod.dart` | `env/.env.prod` |

```bash
flutter run -t lib/main_dev.dart
flutter build apk -t lib/main_prod.dart --release
```

## Tech Stack

| Category | Package |
|----------|---------|
| State | flutter_bloc |
| DI | get_it |
| Network | dio |
| Storage | hive, flutter_secure_storage, shared_preferences |
| Navigation | go_router |
| Localization | flutter gen-l10n |
| Testing | mocktail, bloc_test |
| Linting | very_good_analysis |

## License

Proprietary — Internal use only.
