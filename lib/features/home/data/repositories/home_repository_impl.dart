import '../../../../core/base/data/base_repository.dart';
import '../../../../core/resources/result.dart';
import '../../domain/entities/user_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  HomeRepositoryImpl({required HomeRemoteDataSource remote}) : _remote = remote;
  final HomeRemoteDataSource _remote;

  @override
  Future<Result<UsersPage>> getUsers({required int page}) => execute(() async {
        final response = await _remote.getUsers(page: page);
        return UsersPage(users: response.items, page: response.page, hasMore: response.hasMore);
      });
}
