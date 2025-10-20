import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message});

  final Object? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Card(
        child: Padding(padding: EdgeInsets.all(24), child: Text('Error: $message')),
      ),
    );
  }
}
