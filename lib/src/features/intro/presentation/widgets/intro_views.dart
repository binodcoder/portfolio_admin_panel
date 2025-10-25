import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/error_card.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_card.dart';

class IntroLoadingView extends StatelessWidget {
  const IntroLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Sizes.p32),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class IntroErrorView extends StatelessWidget {
  const IntroErrorView({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: ErrorCard(message: 'Failed to load intro: $error'),
    );
  }
}

class IntroSuccessView extends StatelessWidget {
  const IntroSuccessView({super.key, required this.items});
  final List<Intro> items;

  @override
  Widget build(BuildContext context) {
    final item = items.firstOrNull;
    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: item == null
          ? const EmptyState()
          : IntroCard(text: item.value, padding: const EdgeInsets.all(Sizes.p4)),
    );
  }
}
