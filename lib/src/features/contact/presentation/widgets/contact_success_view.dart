import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';

class ContactSuccessView extends StatelessWidget {
  const ContactSuccessView({super.key, required this.items});

  final List<ContactInfo> items;

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
                const SizedBox(width: 8),
                const Expanded(child: Text('No contact details yet')),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.email != null) Text('Email: ${item.email}'),
              if (item.phone != null) Text('Phone: ${item.phone}'),
              if (item.location != null) Text('Location: ${item.location}'),
              if (item.website != null) Text('Website: ${item.website}'),
              Text('Open to work: ${item.openToWork ? 'Yes' : 'No'}'),
              if (item.message != null) ...[
                const SizedBox(height: 12),
                Text(item.message!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
