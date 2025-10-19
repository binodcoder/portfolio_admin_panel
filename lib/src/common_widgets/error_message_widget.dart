import 'package:flutter/material.dart';

/// Reusable error message widget (just a [Text] with a red color).
class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(this.errorMessage, {super.key});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      errorMessage,
      style: theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.error),
    );
  }
}
