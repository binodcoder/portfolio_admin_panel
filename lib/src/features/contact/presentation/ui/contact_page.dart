import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/alert_dialogs.dart';
import 'package:binodfolioadmin/src/common_widgets/async_value_widget.dart';
import 'package:binodfolioadmin/src/common_widgets/empty_state.dart';
import 'package:binodfolioadmin/src/common_widgets/responsive_center.dart';
import 'package:binodfolioadmin/src/features/contact/data/contact_repository.dart';
import 'package:binodfolioadmin/src/features/contact/domain/contact_info.dart';
import 'package:binodfolioadmin/src/features/contact/presentation/controller/contact_controller.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/routing/app_router.dart';

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

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref, String id) async {
    final delete = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );
    if (delete == true) {
      await ref.read(contactControllerProvider.notifier).deleteContact(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(contactControllerProvider);
    final state = ref.watch(contactInfoListProvider);

    //new line
    final items = state.asData?.value ?? const <ContactInfo>[];

    return AppBar(
      title: const Text('Contact'),
      actions: [
        TextButton.icon(
          onPressed: () => context.goNamed(
            AppRoute.contactEdit.name,
            extra: items.isNotEmpty ? items.first : null,
          ),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: (action.isLoading || items.isEmpty)
              ? null
              : () => _confirmAndDelete(context, ref, items.first.id!),
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

    return SingleChildScrollView(
      child: ResponsiveCenter(
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
