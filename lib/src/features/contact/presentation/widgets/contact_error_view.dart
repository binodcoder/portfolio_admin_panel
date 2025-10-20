import 'package:flutter/material.dart';

class ContactErrorView extends StatelessWidget {
  const ContactErrorView({super.key, required this.message});

  final Object? message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error: $message'));
  }
}
