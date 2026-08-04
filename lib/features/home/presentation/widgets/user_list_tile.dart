import 'package:flutter/material.dart';

import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/user_item.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.user});
  final UserItem user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AppAvatar(imageUrl: user.avatarUrl, name: user.displayName, radius: 20),
      title: Text(user.displayName),
      subtitle: Text(user.email),
    );
  }
}
