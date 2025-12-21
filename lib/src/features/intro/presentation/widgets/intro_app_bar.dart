import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class IntroAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const IntroAppBar({super.key});

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
      await ref.read(introControllerProvider.notifier).deleteIntro(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introList = ref.watch(watchIntrosProvider);
    final List<Intro?> existing = introList.asData?.value ?? const [];
    final hasItem = existing.isNotEmpty;
    final actionState = ref.watch(introControllerProvider);
    // final introState = ref.watch(watchIntrosProvider);

    return AppBar(
      title: Text('Intro'.hardcoded),
      actions: [
        TextButton.icon(
          onPressed: () => hasItem
              ? context.goNamed(AppRoute.introForm.name, extra: existing.first)
              : context.goNamed(AppRoute.introForm.name, extra: null),

          icon: Icon(hasItem ? Icons.edit_outlined : Icons.add_outlined),
          label: Text(hasItem ? 'Edit'.hardcoded : 'Add'.hardcoded),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: (actionState.isLoading || !hasItem)
              ? null
              : () => _confirmAndDelete(context, ref, existing.first!.id!),

          icon: const Icon(Icons.delete_outline),
          label: Text('Delete'.hardcoded),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
