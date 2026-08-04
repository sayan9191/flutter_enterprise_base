import 'package:flutter/material.dart';

import 'app_network_image.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.imageUrl, this.name, this.radius = 24});

  final String? imageUrl;
  final String? name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ClipOval(
          child: AppNetworkImage(url: imageUrl!, width: radius * 2, height: radius * 2),
        ),
      );
    }
    final initial = (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(initial, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
    );
  }
}
