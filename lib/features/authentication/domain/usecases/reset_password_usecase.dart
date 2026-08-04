import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  ResetPasswordUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<void>> call(ResetPasswordParams params) =>
      _repository.resetPassword(email: params.email, password: params.password);
}

class ResetPasswordParams {
  const ResetPasswordParams({required this.email, required this.password});
  final String email;
  final String password;
}
