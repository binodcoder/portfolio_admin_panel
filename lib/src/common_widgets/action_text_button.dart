import 'package:flutter/material.dart';
import 'package:binodfolioadmin/src/constants/app_sizes.dart';

/// Text button to be used as an [AppBar] action
class ActionTextButton extends StatelessWidget {
  const ActionTextButton({super.key, required this.text, this.onPressed});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: TextButton(
        onPressed: onPressed,
        child: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            final color =
                theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;
            return Text(text, style: theme.textTheme.titleLarge!.copyWith(color: color));
          },
        ),
      ),
    );
  }
}
