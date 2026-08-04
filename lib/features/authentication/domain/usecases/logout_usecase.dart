import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  LogoutUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<void>> call(NoParams params) => _repository.logout();
}
