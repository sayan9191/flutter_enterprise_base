import '../../domain/entities/user_item.dart';

class UserItemModel extends UserItem {
  const UserItemModel({required super.id, required super.email, super.firstName, super.lastName, super.avatarUrl});
  factory UserItemModel.fromJson(Map<String, dynamic> json) => UserItemModel(
        id: json['id'] as int? ?? 0,
        email: json['email'] as String? ?? '',
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        avatarUrl: json['avatar'] as String?,
      );
}
