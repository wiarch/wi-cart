import 'package:flutter/material.dart';

/// Shared "+" action button. Default bottom-right (FloatingActionButtonLocation.endFloat).
class AddFab extends StatelessWidget {
  const AddFab({super.key, required this.onPressed, this.tooltip = 'Agregar'});

  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onPressed,
      child: const Icon(Icons.add, size: 28),
    );
  }
}
