# Architecture

## Overview

This project follows **Feature-First Clean Architecture** with clear separation of concerns across three layers per feature.

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation                          │
│  (Pages, Widgets, BLoC/Cubit, Events, States)           │
├─────────────────────────────────────────────────────────┤
│                      Domain                              │
│  (Entities, Repository Interfaces, Use Cases)            │
├─────────────────────────────────────────────────────────┤
│                       Data                               │
│  (Models/DTOs, Mappers, DataSources, Repository Impl)   │
└─────────────────────────────────────────────────────────┘
```

## Dependency Rule

Dependencies point **inward only**:

- Presentation → Domain
- Data → Domain
- Domain → **nothing** (pure Dart)

## Layer Responsibilities

### Presentation
- UI rendering and user interaction
- BLoC state management
- Navigation triggers
- **Never** contains business logic or direct API calls

### Domain
- Business entities (pure Dart classes)
- Repository contracts (abstract classes)
- Use cases (single-responsibility operations)
- Returns `Result<T>` — never throws

### Data
- API calls via `ApiService`
- Local storage via abstractions
- DTO/Model classes with JSON serialization
- Mappers (Model ↔ Entity)
- Repository implementations

## Core Patterns

| Pattern | Implementation |
|---------|---------------|
| Repository | `BaseRepository` + feature repositories |
| Use Case | `UseCase<Type, Params>` base class |
| DTO/Mapper | `BaseMapper<Entity, Model>` |
| DI | GetIt service locator |
| Result | `Result<T>` sealed class |
| Observer | BLoC + `BlocObserver` |
| Strategy | Repository decides remote/local/cache |
| Factory | `FlavorConfig`, model factories |
| Singleton | GetIt lazy singletons |
| Builder | `PaginationResponse`, form builders |

## Data Flow

```
User Action → Event → BLoC → UseCase → Repository → DataSource → API/Cache
                ↓
              State → UI rebuild
```

## Offline-First Strategy

Repositories implement a decision tree:

1. **Online** → Fetch remote → Cache locally → Return fresh data
2. **Offline** → Return cached data if valid
3. **Offline + No Cache** → Return `NetworkFailure`
4. **Background** → Queue pending mutations for sync

## Error Handling

```
Exception (Data Layer) → ErrorMapper → Failure (Domain Layer) → BLoC State → UI Message
```

## Scalability

Designed to support **100+ features**:

- Each feature is self-contained under `lib/features/<name>/`
- Shared code lives in `lib/core/` and `lib/shared/`
- DI registration is modular (per-feature extension methods)
- Routes are feature-scoped constants

## Key Base Classes

| Class | Purpose |
|-------|---------|
| `BaseBloc` | Logging + error mapping |
| `BaseRepository` | Exception → Failure wrapping |
| `UseCase` | Single-responsibility domain ops |
| `BaseMapper` | DTO ↔ Entity conversion |
| `Result<T>` | Functional success/failure |
| `ViewStatus` | Generic loading states |

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for step-by-step feature creation.
