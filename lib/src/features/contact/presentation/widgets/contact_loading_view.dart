import 'package:flutter/material.dart';

class ContactLoadingView extends StatelessWidget {
  const ContactLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
    );
  }
}
