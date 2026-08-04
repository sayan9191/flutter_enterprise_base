# Testing Guide

## Setup

Test dependencies in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  bloc_test: ^10.0.0
```

## Test Structure

```
test/
├── unit/              # Pure logic tests
├── widget/            # Widget tests
├── bloc/              # BLoC state transition tests
├── repository/        # Repository tests with mocks
└── core/              # Core utility tests
```

## Running Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Specific file
flutter test test/features/auth/auth_bloc_test.dart

# Watch mode (via IDE)
```

## Unit Tests

Test pure functions and use cases:

```dart
// test/core/resources/result_test.dart
test('Success.isSuccess returns true', () {
  const result = Success(42);
  expect(result.isSuccess, isTrue);
  expect(result.isFailure, isFalse);
});
```

## BLoC Tests

Use `bloc_test` for state transition verification:

```dart
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLogin;
  late AuthBloc bloc;

  setUp(() {
    mockLogin = MockLoginUseCase();
    bloc = AuthBloc(loginUseCase: mockLogin, logger: MockAppLogger());
  });

  blocTest<AuthBloc, AuthState>(
    'emits success when login succeeds',
    build: () {
      when(() => mockLogin(any())).thenAnswer(
        (_) async => Success(User(id: 1, email: 'test@test.com')),
      );
      return bloc;
    },
    act: (b) => b.add(LoginRequested(email: 'test@test.com', password: 'pass')),
    expect: () => [
      isA<AuthState>().having((s) => s.status, 'status', ViewStatus.loading),
      isA<AuthState>().having((s) => s.status, 'status', ViewStatus.success),
    ],
  );
}
```

## Widget Tests

```dart
testWidgets('App widget can be instantiated', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: Text('Test'))),
  );
  expect(find.text('Test'), findsOneWidget);
});
```

## Repository Tests

Mock data sources and verify offline/online behavior:

```dart
test('returns cached data when offline', () async {
  when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  when(() => mockLocal.getCachedUsers(1)).thenReturn([userEntity]);

  final result = await repository.getUsers(page: 1);

  expect(result.isSuccess, isTrue);
  verifyNever(() => mockRemote.fetchUsers(page: 1));
});
```

## Mocking with Mocktail

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

// Stubbing
when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
    .thenAnswer((_) async => Success(user));

// Verification
verify(() => mockRepo.login(email: 'test@test.com', password: 'pass')).called(1);
```

## CI Integration

Tests run in GitHub Actions on every push/PR:

```yaml
- run: flutter test --coverage
```

## Coverage Targets

| Layer | Target |
|-------|--------|
| Domain (Use Cases) | 90%+ |
| Data (Repositories) | 80%+ |
| BLoC | 85%+ |
| Widgets | 60%+ |

## Best Practices

1. Test behavior, not implementation
2. One assertion concept per test
3. Use descriptive test names: `'emits failure when network is unavailable'`
4. Mock at repository boundary, not HTTP level (for unit tests)
5. Use `setUp`/`tearDown` for common initialization
6. Keep widget tests focused — test one widget at a time
7. Use golden tests for critical UI components (optional)

## Integration Tests

For end-to-end flows, add `integration_test/`:

```dart
// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    // ... interact with login form
  });
}
```

Run: `flutter test integration_test/`
