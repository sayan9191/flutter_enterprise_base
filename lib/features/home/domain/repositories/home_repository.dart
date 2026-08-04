import '../../../../core/resources/result.dart';
import '../entities/user_item.dart';

class UsersPage {
  const UsersPage({required this.users, required this.page, required this.hasMore});
  final List<UserItem> users;
  final int page;
  final bool hasMore;
}

abstract class HomeRepository {
  Future<Result<UsersPage>> getUsers({required int page});
}
