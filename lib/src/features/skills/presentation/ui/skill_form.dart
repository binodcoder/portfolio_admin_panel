import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/controller/skill_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/controller/skill_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SkillForm extends ConsumerWidget {
  const SkillForm({super.key, this.item});
  final Skill? item;

  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(skillFormProvider(item));
    final notifier = ref.read(skillFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Skill'.hardcoded : 'New Skill'.hardcoded),
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
                      controller: TextEditingController(text: state.name)
                        ..selection = TextSelection.collapsed(offset: state.name.length),
                      onChanged: notifier.nameChanged,
                      labelText: 'Name'.hardcoded,
                      errorText: state.nameError,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    CustomTextField(
                      controller: TextEditingController(text: state.category)
                        ..selection = TextSelection.collapsed(
                          offset: state.category.length,
                        ),
                      onChanged: notifier.categoryChanged,
                      labelText: 'Category (optional)'.hardcoded,
                      errorText: null,
                      enabled: !state.isSubmitting,
                    ),
                    gapH12,
                    Text('Level: ${state.level.round()}%'),
                    Slider(
                      value: state.level,
                      onChanged: state.isSubmitting ? null : notifier.levelChanged,
                      min: 0,
                      max: 100,
                      divisions: 20,
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
