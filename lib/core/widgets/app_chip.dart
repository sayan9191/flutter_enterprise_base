import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, this.onDeleted, this.selected = false});

  final String label;
  final VoidCallback? onDeleted;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
      onDeleted: onDeleted,
    );
  }
}
