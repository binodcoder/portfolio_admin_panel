import 'package:flutter/material.dart';
import 'package:binodfolioadmin/src/constants/breakpoints.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < Breakpoint.mobile;
            final titleStyle = theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            );
            final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            );

            if (isNarrow) {
              return _NarrowHeader(titleStyle: titleStyle, subtitleStyle: subtitleStyle);
            }

            return _WideHeader(titleStyle: titleStyle, subtitleStyle: subtitleStyle);
          },
        ),
      ),
    );
  }
}

class _NarrowHeader extends StatelessWidget {
  const _NarrowHeader({required this.titleStyle, required this.subtitleStyle});

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome to your Admin', style: titleStyle),
                  const SizedBox(height: 6),
                  Text(
                    'Manage your portfolio content quickly and comfortably on the web.',
                    style: subtitleStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WideHeader extends StatelessWidget {
  const _WideHeader({required this.titleStyle, required this.subtitleStyle});

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to your Admin', style: titleStyle),
              const SizedBox(height: 8),
              Text(
                'Manage your portfolio content quickly and comfortably on the web.',
                style: subtitleStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
