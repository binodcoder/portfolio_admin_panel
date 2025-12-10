import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/widgets/about_app_bar.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/widgets/about_body.dart';
import 'package:portfolio_admin_panel/src/utils/async_value_ui.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      aboutControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    return Scaffold(appBar: AboutAppBar(), body: AboutBody());
  }
}
