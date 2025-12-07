import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class IntroAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const IntroAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(introActionControllerProvider);
    final introState = ref.watch(watchIntroProvider);

    final currentIntro = introState.asData?.value;

    return AppBar(
      title: Text('Intro'.hardcoded),
      actions: [
        TextButton.icon(
          onPressed: () {
            context.goNamed(AppRoute.introEdit.name, pathParameters: {'id': 'current'});
          },
          icon: Icon(currentIntro == null ? Icons.add_outlined : Icons.edit_outlined),
          label: Text(currentIntro == null ? 'Add'.hardcoded : 'Edit'.hardcoded),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: (actionState.isLoading || currentIntro == null)
              ? null
              : () async {
                  final logout = await showAlertDialog(
                    context: context,
                    title: 'Are you sure?'.hardcoded,
                    cancelActionText: 'Cancel'.hardcoded,
                    defaultActionText: 'Delete'.hardcoded,
                  );
                  if (logout == true) {
                    await ref.read(introActionControllerProvider.notifier).deleteIntro();
                  }
                },

          icon: const Icon(Icons.delete_outline),
          label: Text('Delete'.hardcoded),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
