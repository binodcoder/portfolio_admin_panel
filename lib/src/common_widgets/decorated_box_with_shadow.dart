import 'package:flutter/material.dart';
import 'package:binodfolioadmin/src/constants/app_sizes.dart';

/// Custom [DecoratedBox] widget with shadow to be used at the bottom of the
/// screen on mobile. Useful for pinning CTAs such as checkout buttons etc.
class DecoratedBoxWithShadow extends StatelessWidget {
  const DecoratedBoxWithShadow({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.12),
            offset: const Offset(0.0, 1.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(Sizes.p16), child: child),
    );
  }
}
