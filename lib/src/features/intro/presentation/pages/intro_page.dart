import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_app_bar.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_body.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_dialogs.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(introActionControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          final last = ref.read(introActionControllerProvider.notifier).lastAction;
          final msg = last == IntroActionKind.delete
              ? 'Intro deleted successfully'.hardcoded
              : 'Saved'.hardcoded;
          IntroDialogs.showSnack(context, msg);
        },
        error: (err, __) {
          final last = ref.read(introActionControllerProvider.notifier).lastAction;
          final msg = last == IntroActionKind.delete
              ? 'Failed to delete: $err'.hardcoded
              : 'Failed to save: $err'.hardcoded;
          IntroDialogs.showSnack(context, msg);
        },
        loading: () {},
      );
    });

    return const Scaffold(appBar: IntroAppBar(), body: IntroBody());
  }
}
