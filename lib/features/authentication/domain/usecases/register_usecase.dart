import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<User, RegisterParams> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<User>> call(RegisterParams params) =>
      _repository.register(email: params.email, password: params.password);
}

class RegisterParams {
  const RegisterParams({required this.email, required this.password});
  final String email;
  final String password;
}
