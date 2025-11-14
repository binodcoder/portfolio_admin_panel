import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_card.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroBody extends ConsumerWidget {
  const IntroBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introValue = ref.watch(introControllerProvider);

    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: AsyncValueWidget<Intro?>(
          value: introValue,
          data: (item) => item == null
              ? EmptyState(
                  title: 'No introduction yet'.hardcoded,
                  subTitle:
                      'Add a short introduction to show on your portfolio.'.hardcoded,
                )
              : IntroSuccessView(item: item),
        ),
      ),
    );
  }
}

class IntroSuccessView extends StatelessWidget {
  const IntroSuccessView({super.key, required this.item});
  final Intro item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: IntroCard(text: item.value, padding: const EdgeInsets.all(Sizes.p4)),
    );
  }
}
