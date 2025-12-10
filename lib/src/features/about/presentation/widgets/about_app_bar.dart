import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/features/about/data/about_repository.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class AboutAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AboutAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutList = ref.watch(aboutListProvider);
    final List<About> existing = aboutList.asData?.value ?? const [];
    final hasItem = existing.isNotEmpty;

    return AppBar(
      title: const Text('About'),
      actions: [
        TextButton.icon(
          onPressed: () => context.goNamed(AppRoute.aboutForm.name),
          icon: hasItem
              ? const Icon(Icons.edit_outlined)
              : const Icon(Icons.add_outlined),
          label: hasItem ? const Text('Edit') : const Text('Add'),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: !hasItem
              ? null
              : () async {
                  final delete = await showAlertDialog(
                    context: context,
                    title: 'Are you sure?'.hardcoded,
                    cancelActionText: 'Cancel'.hardcoded,
                    defaultActionText: 'Delete'.hardcoded,
                  );
                  if (delete == true) {
                    await ref
                        .read(aboutControllerProvider.notifier)
                        .deleteAbout(existing.first.id!);
                  }
                },
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
