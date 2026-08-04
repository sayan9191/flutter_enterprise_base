import 'package:equatable/equatable.dart';

class UserItem extends Equatable {
  const UserItem({required this.id, required this.email, this.firstName, this.lastName, this.avatarUrl});
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  String get displayName => firstName != null ? '$firstName ${lastName ?? ''}'.trim() : email;
  @override
  List<Object?> get props => [id, email, firstName, lastName, avatarUrl];
}
