# State Management

## Overview

State management uses **flutter_bloc** with a hierarchy of base classes providing consistent patterns across all features.

## Base Classes

| Class | Location | Purpose |
|-------|----------|---------|
| `BaseEvent` | `core/base/bloc/base_event.dart` | Equatable events |
| `BaseState` | `core/base/bloc/base_state.dart` | ViewStatus + Failure |
| `BaseBloc` | `core/base/bloc/base_bloc.dart` | Logging + error mapping |
| `PaginationBloc` | `core/base/bloc/pagination_bloc.dart` | Paginated lists |
| `SearchBloc` | `core/base/bloc/search_bloc.dart` | Debounced search |

## ViewStatus

Generic loading states used by all features:

```dart
enum ViewStatus {
  initial,        // Before first load
  loading,        // First load in progress
  refreshing,     // Pull-to-refresh
  loadingMore,    // Pagination load
  success,        // Data loaded
  failure,        // Generic error
  empty,          // No data
  noInternet,     // Offline
  unauthorized,   // Session expired
  serverError,    // 5xx
  unknownError,   // Unmapped error
}
```

## BLoC Observer

`AppBlocObserver` logs all BLoC events and state transitions in debug mode:

```dart
Bloc.observer = AppBlocObserver(logger: getIt<AppLogger>());
```

## Feature BLoC Pattern

```dart
// Events
sealed class HomeEvent extends BaseEvent {}
class LoadHome extends HomeEvent {}
class RefreshHome extends HomeEvent {}
class LoadMoreHome extends HomeEvent {}

// State
class HomeState extends PaginationState<UserItem> {
  const HomeState({super.status, super.failure, super.items, super.page, super.hasMore});

  factory HomeState.initial() => const HomeState();
  
  @override
  HomeState copyWithPagination({/* ... */}) => HomeState(/* ... */);
}

// BLoC
class HomeBloc extends PaginationBloc<UserItem, HomeState> {
  // Handle LoadInitialPage, LoadNextPage, RefreshPage
}
```

## UI Integration

```dart
BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    return switch (state.status) {
      ViewStatus.loading => const AppLoadingIndicator(),
      ViewStatus.empty => const AppEmptyState(),
      ViewStatus.noInternet => AppErrorView(
          message: 'No internet',
          onRetry: () => context.read<HomeBloc>().add(const LoadInitialPage()),
        ),
      ViewStatus.success => UserList(items: state.items),
      _ => AppErrorView(message: state.failure?.message ?? 'Error'),
    };
  },
)
```

## Result<T> in BLoC

Use cases return `Result<T>`. BLoC maps to ViewStatus:

```dart
final result = await _useCase(params);
result.when(
  success: (data) => emit(state.copyWith(status: ViewStatus.success, data: data)),
  failure: (failure) {
    final status = switch (failure) {
      NetworkFailure() => ViewStatus.noInternet,
      UnauthorizedFailure() => ViewStatus.unauthorized,
      ServerFailure() => ViewStatus.serverError,
      _ => ViewStatus.failure,
    };
    emit(state.copyWith(status: status, failure: failure));
  },
);
```

## Pagination Pattern

1. `LoadInitialPage` → `ViewStatus.loading` → fetch page 1
2. `LoadNextPage` → `ViewStatus.loadingMore` → append page N+1
3. `RefreshPage` → `ViewStatus.refreshing` → reset to page 1

Stop pagination when `hasMore == false`.

## Testing BLoCs

Use `bloc_test` package:

```dart
blocTest<AuthBloc, AuthState>(
  'emits success on valid login',
  build: () => AuthBloc(loginUseCase: mockLogin, logger: mockLogger),
  act: (bloc) => bloc.add(LoginRequested(email: 'test@test.com', password: 'pass')),
  expect: () => [/* state sequence */],
);
```

See `test/features/auth/auth_bloc_test.dart` for examples.
