import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<User, LoginParams> {
  LoginUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<User>> call(LoginParams params) =>
      _repository.login(email: params.email, password: params.password);
}

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}
