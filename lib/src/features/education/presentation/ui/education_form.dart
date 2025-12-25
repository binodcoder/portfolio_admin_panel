import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class EducationForm extends ConsumerWidget {
  const EducationForm({super.key, this.item});
  final Education? item;

  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(educationFormProvider(item));
    final notifier = ref.read(educationFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Education'.hardcoded : 'New Education'.hardcoded),
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
                      controller: TextEditingController(text: state.institution)
                        ..selection = TextSelection.collapsed(
                          offset: state.institution.length,
                        ),
                      onChanged: notifier.institutionChanged,
                      labelText: 'Institution'.hardcoded,
                      errorText: state.institutionError,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.degree)
                              ..selection = TextSelection.collapsed(
                                offset: state.degree.length,
                              ),
                            onChanged: notifier.degreeChanged,
                            labelText: 'Degree (e.g., BSc)'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                        gapW12,
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.field)
                              ..selection = TextSelection.collapsed(
                                offset: state.field.length,
                              ),
                            onChanged: notifier.fieldChanged,
                            labelText: 'Field of study'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                      ],
                    ),
                    gapH12,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.start)
                              ..selection = TextSelection.collapsed(
                                offset: state.start.length,
                              ),
                            onChanged: notifier.startChanged,
                            labelText: 'Start (YYYY-MM)'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                        gapW12,
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.end)
                              ..selection = TextSelection.collapsed(
                                offset: state.end.length,
                              ),
                            onChanged: notifier.endChanged,
                            labelText: 'End (YYYY-MM)'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                      ],
                    ),
                    gapH12,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.location)
                              ..selection = TextSelection.collapsed(
                                offset: state.location.length,
                              ),
                            onChanged: notifier.locationChanged,
                            labelText: 'Location (optional)'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                        gapW12,
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.gpa)
                              ..selection = TextSelection.collapsed(
                                offset: state.gpa.length,
                              ),
                            onChanged: notifier.gpaChanged,
                            labelText: 'GPA (optional)'.hardcoded,
                            errorText: null,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                      ],
                    ),
                    gapH12,
                    TextField(
                      controller: TextEditingController(text: state.description)
                        ..selection = TextSelection.collapsed(
                          offset: state.description.length,
                        ),
                      onChanged: notifier.descriptionChanged,
                      minLines: 3,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description (optional)'.hardcoded,
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
