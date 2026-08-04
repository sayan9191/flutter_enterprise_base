import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  String get displayName {
    if (firstName != null && lastName != null) return '$firstName $lastName';
    return email;
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatarUrl];
}
