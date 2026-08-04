import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:base_structure/core/base/bloc/base_state.dart';
import 'package:base_structure/core/failure/failure.dart';
import 'package:base_structure/core/logger/app_logger.dart';
import 'package:base_structure/core/resources/result.dart';
import 'package:base_structure/features/authentication/domain/entities/user.dart';
import 'package:base_structure/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:base_structure/features/authentication/domain/usecases/login_usecase.dart';
import 'package:base_structure/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:base_structure/features/authentication/domain/usecases/register_usecase.dart';
import 'package:base_structure/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:base_structure/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:base_structure/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:base_structure/features/authentication/presentation/bloc/auth_event.dart';
import 'package:base_structure/features/authentication/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase loginUseCase;
  late MockRegisterUseCase registerUseCase;
  late MockForgotPasswordUseCase forgotPasswordUseCase;
  late MockVerifyOtpUseCase verifyOtpUseCase;
  late MockResetPasswordUseCase resetPasswordUseCase;
  late MockLogoutUseCase logoutUseCase;

  const testUser = User(id: '1', email: 'test@reqres.in');

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    registerUseCase = MockRegisterUseCase();
    forgotPasswordUseCase = MockForgotPasswordUseCase();
    verifyOtpUseCase = MockVerifyOtpUseCase();
    resetPasswordUseCase = MockResetPasswordUseCase();
    logoutUseCase = MockLogoutUseCase();

    bloc = AuthBloc(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      forgotPasswordUseCase: forgotPasswordUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      resetPasswordUseCase: resetPasswordUseCase,
      logoutUseCase: logoutUseCase,
      logger: AppLogger(enabled: false),
    );
  });

  tearDown(() => bloc.close());

  blocTest<AuthBloc, AuthState>(
    'emits success when login succeeds',
    build: () {
      when(() => loginUseCase(any())).thenAnswer((_) async => const Success(testUser));
      return bloc;
    },
    act: (b) => b.add(const AuthLoginRequested(email: 'test@reqres.in', password: 'password')),
    expect: () => [
      isA<AuthState>().having((s) => s.status, 'status', ViewStatus.loading),
      isA<AuthState>()
          .having((s) => s.status, 'status', ViewStatus.success)
          .having((s) => s.user, 'user', testUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits failure when login fails',
    build: () {
      when(() => loginUseCase(any())).thenAnswer(
        (_) async => const FailureResult(ValidationFailure(message: 'Invalid credentials')),
      );
      return bloc;
    },
    act: (b) => b.add(const AuthLoginRequested(email: 'bad@reqres.in', password: 'wrong')),
    expect: () => [
      isA<AuthState>().having((s) => s.status, 'status', ViewStatus.loading),
      isA<AuthState>().having((s) => s.status, 'status', ViewStatus.failure),
    ],
  );
}
