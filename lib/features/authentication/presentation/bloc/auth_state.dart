import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/user.dart';

class AuthState extends BaseState {
  const AuthState({super.status, super.failure, this.user, this.emailForReset});

  final User? user;
  final String? emailForReset;

  AuthState copyWith({
    ViewStatus? status,
    User? user,
    String? emailForReset,
    Failure? failure,
  }) => AuthState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        user: user ?? this.user,
        emailForReset: emailForReset ?? this.emailForReset,
      );

  @override
  List<Object?> get props => [...super.props, user, emailForReset];
}
