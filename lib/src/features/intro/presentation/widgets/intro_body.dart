import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_views.dart';

class IntroBody extends ConsumerWidget {
  const IntroBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introState = ref.watch(introControllerProvider);

    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: introState.when(
          loading: () => const IntroLoadingView(),
          error: (error, _) => IntroErrorView(error: error),
          data: (items) => IntroSuccessView(items: items),
        ),
      ),
    );
  }
}
