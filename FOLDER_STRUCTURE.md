# Folder Structure

```
base_structure/
├── .github/workflows/          # CI/CD pipelines
├── assets/
│   ├── images/                 # PNG/JPG assets
│   ├── icons/                  # App icons
│   ├── svg/                    # Vector assets
│   ├── fonts/                  # Custom font files
│   ├── animations/lottie/      # Lottie animations
│   ├── json/                   # Static JSON data
│   ├── translations/           # Additional translation files
│   ├── audio/                  # Audio assets
│   ├── video/                  # Video assets
│   └── dummy/                  # Mock/placeholder data
├── env/
│   ├── .env.dev                # Development environment
│   ├── .env.qa                 # QA environment
│   ├── .env.stage              # Staging environment
│   └── .env.prod               # Production environment
├── lib/
│   ├── app/
│   │   ├── app.dart            # Root MaterialApp widget
│   │   ├── app_bloc_observer.dart
│   │   └── app_initializer.dart
│   ├── config/
│   │   ├── env/                # Environment manager
│   │   ├── flavors/            # Flavor configuration
│   │   ├── router/             # GoRouter setup
│   │   └── theme/              # Theme config
│   ├── core/
│   │   ├── analytics/
│   │   ├── base/
│   │   │   ├── bloc/           # BaseBloc, PaginationBloc, SearchBloc
│   │   │   ├── data/           # BaseRepository, BaseMapper, BaseDataSource
│   │   │   ├── domain/         # UseCase base
│   │   │   └── presentation/   # BaseScreen
│   │   ├── constants/
│   │   ├── di/                 # GetIt injection
│   │   ├── errors/
│   │   ├── exceptions/
│   │   ├── extensions/
│   │   ├── failure/
│   │   ├── helpers/
│   │   ├── logger/
│   │   ├── network/
│   │   │   ├── interceptors/
│   │   │   └── models/
│   │   ├── permissions/
│   │   ├── resources/          # Result<T>, Resource<T>
│   │   ├── security/
│   │   ├── services/
│   │   ├── storage/
│   │   ├── theme/              # Design tokens
│   │   ├── utils/
│   │   ├── validators/
│   │   └── widgets/            # Shared UI components
│   ├── features/
│   │   ├── authentication/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── local/
│   │   │   │   │   └── remote/
│   │   │   │   ├── models/
│   │   │   │   ├── repositories/
│   │   │   │   └── mapper/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── events/
│   │   │       │   └── states/
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   ├── dashboard/
│   │   ├── home/
│   │   ├── notification/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   ├── search/
│   │   ├── settings/
│   │   └── splash/
│   ├── l10n/                   # ARB localization files
│   ├── main.dart
│   ├── main_dev.dart
│   ├── main_qa.dart
│   ├── main_stage.dart
│   └── main_prod.dart
├── scripts/                    # Build/generation scripts
├── test/
│   ├── bloc/
│   ├── repository/
│   ├── unit/
│   └── widget/
├── analysis_options.yaml
├── codemagic.yaml
├── l10n.yaml
└── pubspec.yaml
```

## Feature Module Template

Every feature follows this structure:

```
features/<feature_name>/
├── data/
│   ├── datasources/
│   │   ├── local/          # Hive/cache data source
│   │   └── remote/         # API data source
│   ├── models/             # JSON DTOs
│   ├── mapper/             # Model ↔ Entity mappers
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Pure Dart business objects
│   ├── repositories/       # Abstract repository contracts
│   └── usecases/           # Single-responsibility operations
└── presentation/
    ├── bloc/
    │   ├── events/         # BLoC events
    │   └── states/         # BLoC states
    ├── pages/              # Screen widgets
    └── widgets/            # Feature-specific widgets
```

Each folder contains a `README.md` explaining its purpose.
