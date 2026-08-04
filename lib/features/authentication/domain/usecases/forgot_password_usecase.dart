import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams> {
  ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<void>> call(ForgotPasswordParams params) =>
      _repository.forgotPassword(email: params.email);
}

class ForgotPasswordParams {
  const ForgotPasswordParams({required this.email});
  final String email;
}
