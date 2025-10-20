import 'package:flutter/material.dart';

class CertificationLoadingView extends StatelessWidget {
  const CertificationLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
    );
  }
}
