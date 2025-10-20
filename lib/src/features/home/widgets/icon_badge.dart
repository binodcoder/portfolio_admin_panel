import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final IconData icon;
  const IconBadge({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 22, color: colorScheme.onPrimaryContainer),
    );
  }
}
