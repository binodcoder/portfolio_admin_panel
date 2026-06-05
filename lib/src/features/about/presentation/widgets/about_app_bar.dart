import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/alert_dialogs.dart';
import 'package:binodfolioadmin/src/features/about/data/about_repository.dart';
import 'package:binodfolioadmin/src/features/about/domain/about.dart';
import 'package:binodfolioadmin/src/features/about/presentation/controller/about_controller.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/routing/app_router.dart';

class AboutAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AboutAppBar({super.key});

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
      await ref.read(aboutControllerProvider.notifier).deleteAbout(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutList = ref.watch(aboutListProvider);
    final List<About?> existing = aboutList.asData?.value ?? const [];
    final hasItem = existing.isNotEmpty;
    final aboutController = ref.watch(aboutControllerProvider);

    return AppBar(
      title: const Text('About'),
      actions: [
        TextButton.icon(
          onPressed: () => hasItem
              ? context.goNamed(AppRoute.aboutForm.name, extra: existing.first)
              : context.goNamed(AppRoute.aboutForm.name, extra: null),
          icon: hasItem
              ? const Icon(Icons.edit_outlined)
              : const Icon(Icons.add_outlined),
          label: hasItem ? const Text('Edit') : const Text('Add'),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: (aboutController.isLoading || !hasItem)
              ? null
              : () => _confirmAndDelete(context, ref, existing.first!.id!),

          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
