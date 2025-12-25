import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ExperienceForm extends ConsumerWidget {
  const ExperienceForm({super.key, this.item});
  final Experience? item;

  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(experienceFormProvider(item));
    final notifier = ref.read(experienceFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _id != null ? 'Edit Experience'.hardcoded : 'New Experience'.hardcoded,
        ),
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
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.company)
                              ..selection = TextSelection.collapsed(
                                offset: state.company.length,
                              ),
                            onChanged: notifier.companyChanged,
                            labelText: 'Company'.hardcoded,
                            errorText: state.companyError,
                            enabled: !state.isSubmitting,
                          ),
                        ),
                        gapW12,
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: state.title)
                              ..selection = TextSelection.collapsed(
                                offset: state.title.length,
                              ),
                            onChanged: notifier.titleChanged,
                            labelText: 'Title / Role'.hardcoded,
                            errorText: state.titleError,
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
                            enabled: !state.isSubmitting && !state.current,
                          ),
                        ),
                      ],
                    ),
                    gapH8,
                    Row(
                      children: [
                        Checkbox(
                          value: state.current,
                          onChanged: state.isSubmitting
                              ? null
                              : (v) => notifier.currentChanged(v ?? false),
                        ),
                        Text('I currently work here'.hardcoded),
                      ],
                    ),
                    gapH12,
                    CustomTextField(
                      controller: TextEditingController(text: state.location)
                        ..selection = TextSelection.collapsed(
                          offset: state.location.length,
                        ),
                      onChanged: notifier.locationChanged,
                      labelText: 'Location (optional)'.hardcoded,
                      errorText: null,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    TextField(
                      controller: TextEditingController(text: state.description)
                        ..selection = TextSelection.collapsed(
                          offset: state.description.length,
                        ),
                      onChanged: notifier.descriptionChanged,
                      minLines: 4,
                      maxLines: null,
                      decoration: InputDecoration(labelText: 'Description'.hardcoded),
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    CustomTextField(
                      controller: TextEditingController(text: state.technologies)
                        ..selection = TextSelection.collapsed(
                          offset: state.technologies.length,
                        ),
                      onChanged: notifier.technologiesChanged,
                      labelText: 'Technologies (comma separated)'.hardcoded,
                      errorText: null,
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
