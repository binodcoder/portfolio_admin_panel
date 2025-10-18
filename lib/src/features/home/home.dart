import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('admin panel'),
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(AppRoute.account.name);
            },
            child: Text('account'),
          ),
        ],
      ),

      body: Text('hello dashboard'),
    );
  }
}
