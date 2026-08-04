import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.height = 1});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, thickness: height);
  }
}
