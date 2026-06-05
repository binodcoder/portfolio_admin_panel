import 'package:flutter/material.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

class CustomLargeTextFormField extends StatelessWidget {
  const CustomLargeTextFormField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 6,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      enabled: !isLoading,
      onChanged: onChanged,
      validator: (value) =>
          (value ?? '').trim().isEmpty ? 'Please enter an introduction'.hardcoded : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: "E.g. I'm a Flutter developer building delightful apps.".hardcoded,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
