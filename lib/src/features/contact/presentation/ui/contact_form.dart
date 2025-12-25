import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ContactForm extends ConsumerWidget {
  const ContactForm({super.key, this.item});
  final ContactInfo? item;

  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactFormProvider(item));
    final notifier = ref.read(contactFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Contact'.hardcoded : 'New Contact'.hardcoded),
        actions: [
          SaveButton(
            onSave: !state.canSubmit
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
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: TextEditingController(text: state.email)
                        ..selection = TextSelection.collapsed(offset: state.email.length),
                      onChanged: notifier.emailChanged,
                      labelText: 'Email'.hardcoded,
                      errorText: null,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.phone)
                              ..selection = TextSelection.collapsed(
                                offset: state.phone.length,
                              ),
                            onChanged: notifier.phoneChanged,
                            labelText: 'Phone'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                        gapW12,
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.location)
                              ..selection = TextSelection.collapsed(
                                offset: state.location.length,
                              ),
                            onChanged: notifier.locationChanged,
                            labelText: 'Location'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                      ],
                    ),
                    gapH12,
                    CustomTextField(
                      controller: TextEditingController(text: state.website)
                        ..selection = TextSelection.collapsed(
                          offset: state.website.length,
                        ),
                      onChanged: notifier.websiteChanged,
                      labelText: 'Website'.hardcoded,
                      errorText: null,
                      enabled: !state.isSubmitting,
                    ),
                    gapH8,
                    Row(
                      children: [
                        Switch(
                          value: state.openToWork,
                          onChanged: state.isSubmitting
                              ? null
                              : notifier.openToWorkChanged,
                        ),
                        gapW8,
                        Text('Open to work'.hardcoded),
                      ],
                    ),
                    gapH12,
                    TextField(
                      controller: TextEditingController(text: state.message)
                        ..selection = TextSelection.collapsed(
                          offset: state.message.length,
                        ),
                      onChanged: notifier.messageChanged,
                      minLines: 3,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Contact message (optional)'.hardcoded,
                      ),
                      enabled: !state.isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
