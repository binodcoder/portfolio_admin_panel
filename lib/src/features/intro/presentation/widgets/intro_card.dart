import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
  });

  final String text;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: SelectionArea(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}
