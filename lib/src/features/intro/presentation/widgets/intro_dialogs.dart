import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroDialogs {
  static Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete intro?'.hardcoded),
            content: Text('This action cannot be undone.'.hardcoded),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'.hardcoded),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete'.hardcoded),
              ),
            ],
          ),
        ) ??
        false;
  }

  static void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
