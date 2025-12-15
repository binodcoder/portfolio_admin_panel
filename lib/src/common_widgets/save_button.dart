import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onSave, required this.isLoading});
  final VoidCallback? onSave;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onSave,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check_outlined),
      label: const Text('Save'),
    );
  }
}
