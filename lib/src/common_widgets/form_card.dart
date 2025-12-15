import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_form_field.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class FormCard extends StatelessWidget {
  const FormCard({
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introduction'.hardcoded,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              'This appears on your portfolio landing page.'.hardcoded,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            gapH20,

            CustomTextFormField(
              controller: controller,
              isLoading: isLoading,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
