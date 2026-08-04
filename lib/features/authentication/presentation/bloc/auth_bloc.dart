import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_bloc.dart';
import '../../../../core/base/domain/usecase.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required LogoutUseCase logoutUseCase,
    required AppLogger logger,
  })  : _login = loginUseCase,
        _register = registerUseCase,
        _forgot = forgotPasswordUseCase,
        _verifyOtp = verifyOtpUseCase,
        _reset = resetPasswordUseCase,
        _logout = logoutUseCase,
        super(const AuthState(), logger: logger) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthForgotPasswordRequested>(_onForgot);
    on<AuthOtpVerifyRequested>(_onOtp);
    on<AuthResetPasswordRequested>(_onReset);
    on<AuthLogoutRequested>(_onLogout);
  }

  final LoginUseCase _login;
  final RegisterUseCase _register;
  final ForgotPasswordUseCase _forgot;
  final VerifyOtpUseCase _verifyOtp;
  final ResetPasswordUseCase _reset;
  final LogoutUseCase _logout;

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _login(LoginParams(email: e.email, password: e.password));
    result.when(
      success: (user) => emit(state.copyWith(status: ViewStatus.success, user: user)),
      orElse: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _register(RegisterParams(email: e.email, password: e.password));
    result.when(
      success: (user) => emit(state.copyWith(status: ViewStatus.success, user: user)),
      orElse: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }

  Future<void> _onForgot(AuthForgotPasswordRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _forgot(ForgotPasswordParams(email: e.email));
    result.when(
      success: (_) => emit(state.copyWith(status: ViewStatus.success, emailForReset: e.email)),
      orElse: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }

  Future<void> _onOtp(AuthOtpVerifyRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _verifyOtp(VerifyOtpParams(email: e.email, otp: e.otp));
    result.when(
      success: (_) => emit(state.copyWith(status: ViewStatus.success)),
      orElse: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }

  Future<void> _onReset(AuthResetPasswordRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _reset(ResetPasswordParams(email: e.email, password: e.password));
    result.when(
      success: (_) => emit(state.copyWith(status: ViewStatus.success)),
      orElse: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _logout(const NoParams());
    result.when(
      success: (_) => emit(const AuthState(status: ViewStatus.success)),
      orElse: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }
}
