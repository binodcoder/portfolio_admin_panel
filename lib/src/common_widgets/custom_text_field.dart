import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.labelText,
    required this.errorText,
    required this.enabled,
  });

  final TextEditingController controller;
  final Function(String)? onChanged;
  final String labelText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText, errorText: errorText),
      enabled: enabled,
    );
  }
}
