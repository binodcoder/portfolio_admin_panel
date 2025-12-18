import 'package:flutter/material.dart';

class TextAreaCard extends StatelessWidget {
  const TextAreaCard({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 8,
  });

  final String text;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          //  border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding,
          child: SelectionArea(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.55,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
