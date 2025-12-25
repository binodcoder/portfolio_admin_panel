import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class AboutForm extends ConsumerWidget {
  const AboutForm({super.key, this.about});

  final About? about;

  String? get _id => about?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aboutFormProvider(about));
    final notifier = ref.read(aboutFormProvider(about).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit About'.hardcoded : 'New About'.hardcoded),
        actions: [
          SaveButton(
            onSave: !state.isValid
                ? null
                : () async {
                    final success = await notifier.submit(id: _id);
                    if (context.mounted && success) {
                      context.pop();
                    }
                  },
            isLoading: state.isSubmitting,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p4,
              vertical: Sizes.p24,
            ),
            child: TextField(
              controller: TextEditingController(text: state.aboutText)
                ..selection = TextSelection.collapsed(offset: state.aboutText.length),
              onChanged: notifier.aboutTextChanged,
              decoration: InputDecoration(
                labelText: 'Enter Introduction'.hardcoded,
                errorText: state.aboutError,
              ),
              enabled: !state.isSubmitting,
            ),
          ),
        ),
      ),
    );
  }
}
