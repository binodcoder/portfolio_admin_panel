import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/project_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/project_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ProjectForm extends ConsumerWidget {
  const ProjectForm({super.key, this.item});
  final Project? item;

  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectFormProvider(item));
    final notifier = ref.read(projectFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Project'.hardcoded : 'New Project'.hardcoded),
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
                      controller: TextEditingController(text: state.title)
                        ..selection = TextSelection.collapsed(offset: state.title.length),
                      onChanged: notifier.titleChanged,
                      labelText: 'Title'.hardcoded,
                      errorText: state.titleError,
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
                      controller: TextEditingController(text: state.repoUrl)
                        ..selection = TextSelection.collapsed(
                          offset: state.repoUrl.length,
                        ),
                      onChanged: notifier.repoChanged,
                      labelText: 'Repository URL (optional)'.hardcoded,
                      errorText: null,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    CustomTextField(
                      controller: TextEditingController(text: state.liveUrl)
                        ..selection = TextSelection.collapsed(
                          offset: state.liveUrl.length,
                        ),
                      onChanged: notifier.liveChanged,
                      labelText: 'Live URL (optional)'.hardcoded,
                      errorText: null,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    CustomTextField(
                      controller: TextEditingController(text: state.tags)
                        ..selection = TextSelection.collapsed(offset: state.tags.length),
                      onChanged: notifier.tagsChanged,
                      labelText: 'Tags (comma separated)'.hardcoded,
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
