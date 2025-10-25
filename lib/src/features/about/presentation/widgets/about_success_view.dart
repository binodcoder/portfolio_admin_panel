import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';

class AboutSuccessView extends StatelessWidget {
  const AboutSuccessView({super.key, required this.items});

  final List<About> items;

  @override
  Widget build(BuildContext context) {
    final item = items.isNotEmpty ? items.first : null;
    if (item == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 12),
                const Expanded(child: Text('No content yet')),
              ],
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SelectionArea(
            child: Text(item.value, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}
