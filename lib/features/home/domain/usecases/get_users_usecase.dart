import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../repositories/home_repository.dart';

class GetUsersUseCase extends UseCase<UsersPage, GetUsersParams> {
  GetUsersUseCase(this._repository);
  final HomeRepository _repository;
  @override
  Future<Result<UsersPage>> call(GetUsersParams params) => _repository.getUsers(page: params.page);
}

class GetUsersParams {
  const GetUsersParams({required this.page});
  final int page;
}
