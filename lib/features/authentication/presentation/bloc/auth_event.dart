import '../../../../core/base/bloc/base_event.dart';

abstract class AuthEvent extends BaseEvent {
  const AuthEvent();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
}

class AuthOtpVerifyRequested extends AuthEvent {
  const AuthOtpVerifyRequested({required this.email, required this.otp});
  final String email;
  final String otp;
  @override
  List<Object?> get props => [email, otp];
}

class AuthResetPasswordRequested extends AuthEvent {
  const AuthResetPasswordRequested({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
