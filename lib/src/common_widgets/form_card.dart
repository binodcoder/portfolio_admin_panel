import 'package:flutter/material.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_large_text_form_field.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';

class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.controller,
    required this.isLoading,
    required this.onChanged,
  });

  final String title;
  final String subTitle;
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
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(subTitle, style: Theme.of(context).textTheme.bodySmall),
            gapH20,

            CustomLargeTextFormField(
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
