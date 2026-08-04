# Coding Guidelines

## Principles

- **SOLID** — Single responsibility, open/closed, dependency inversion
- **DRY** — Don't repeat yourself; extract shared logic to core/
- **KISS** — Keep it simple; avoid premature abstraction
- **YAGNI** — You aren't gonna need it; don't build unused features

## Architecture Rules

1. **No business logic in UI** — Widgets only render and dispatch events
2. **No direct API calls from BLoC** — Always go through UseCase → Repository
3. **No direct storage access** — Use abstraction services
4. **Domain layer is pure Dart** — No Flutter imports in domain/
5. **Dependencies point inward** — Presentation → Domain ← Data

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Files | snake_case | `auth_repository_impl.dart` |
| Classes | PascalCase | `AuthRepositoryImpl` |
| Variables | camelCase | `accessToken` |
| Constants | camelCase or SCREAMING | `AppConstants.defaultPageSize` |
| Private | _prefix | `_repository` |
| BLoC Events | Verb + Noun | `LoginRequested` |
| BLoC States | Noun + State | `AuthState` |
| Use Cases | Verb + UseCase | `LoginUseCase` |

## File Organization

```dart
// 1. Imports (dart → flutter → packages → project)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:base_structure/core/failure/failure.dart';

// 2. Class definition
// 3. Public methods
// 4. Private methods
```

Use `package:` imports for all project files (not relative).

## Documentation

Every public class and method should have dartdoc:

```dart
/// Authenticates user with email and password.
///
/// Returns [Result<User>] with token stored on success.
class LoginUseCase extends UseCase<User, LoginParams> {
  /// Creates a [LoginUseCase] with the given [repository].
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(LoginParams params) { /* ... */ }
}
```

## Error Handling

```dart
// DO: Return Result in domain
Future<Result<User>> login() async {
  try {
    return Success(await _remote.login());
  } catch (e) {
    return FailureResult(_errorMapper.mapException(e));
  }
}

// DON'T: Throw in domain layer
Future<User> login() async {
  throw Exception('Login failed'); // Bad
}
```

## State Management

```dart
// DO: Use copyWith for immutable states
emit(state.copyWith(status: ViewStatus.loading));

// DON'T: Mutate state directly
state.status = ViewStatus.loading; // Bad
state.items.add(item); // Bad
```

## Widget Guidelines

- Prefer `const` constructors
- Extract widgets when build method exceeds ~80 lines
- Use shared widgets from `core/widgets/`
- No hardcoded strings — use localization
- No hardcoded colors — use theme tokens

## Linting

Project uses `very_good_analysis` with `dart_code_metrics`:

```bash
flutter analyze
dart run dart_code_metrics:metrics analyze lib
```

## Git Conventions

```
feat: add order tracking feature
fix: resolve token refresh race condition
refactor: extract pagination logic to base bloc
test: add auth bloc unit tests
docs: update architecture guide
chore: upgrade dio to 5.8.0
```

## Code Review Checklist

- [ ] Follows Clean Architecture layers
- [ ] No business logic in presentation
- [ ] Proper error handling with Result/Failure
- [ ] Tests included for new logic
- [ ] Documentation on public APIs
- [ ] No hardcoded strings or colors
- [ ] DI registered for new services
- [ ] Routes added for new screens
