import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_app_bar.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_body.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: IntroAppBar(), body: IntroBody());
  }
}
