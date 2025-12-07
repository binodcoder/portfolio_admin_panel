import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_app_bar.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_body.dart';

import 'package:portfolio_admin_panel/src/utils/async_value_ui.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      introActionControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    return const Scaffold(appBar: IntroAppBar(), body: IntroBody());
  }
}
