import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/features/contact/data/contact_repository.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(contactControllerProvider);
    final state = ref.watch(contactInfoListProvider);

    Future<void> deleteItem() async {
      final items = state.asData?.value ?? const <ContactInfo>[];
      if (items.isEmpty || items.first.id == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Nothing to delete')));
        return;
      }
      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete contact details?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirm) return;
      await ref.read(contactControllerProvider.notifier).deleteContact(items.first.id!);
    }

    void editItem() {
      final List<ContactInfo> existing = state.asData?.value ?? const [];
      context.goNamed(
        AppRoute.contactEdit.name,
        extra: existing.isNotEmpty ? existing.first : null,
      );
    }

    return AppBar(
      title: const Text('Contact'),
      actions: [
        TextButton.icon(
          onPressed: editItem,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: action.isLoading ? null : deleteItem,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactInfoListProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: AsyncValueWidget(
          value: state,
          data: (items) {
            final item = items.isNotEmpty ? items.first : null;

            if (item == null) {
              return EmptyState(
                title: "No contact yet".hardcoded,
                subTitle: "Try Adding contact".hardcoded,
              );
            }
            return ContactSuccessView(item: item);
          },
        ),
      ),
    );
  }
}

class ContactSuccessView extends StatelessWidget {
  const ContactSuccessView({super.key, required this.item});

  final ContactInfo item;

  @override
  Widget build(BuildContext context) {
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
