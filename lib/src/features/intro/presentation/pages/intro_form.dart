import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroForm extends ConsumerWidget {
  const IntroForm({super.key, this.intro});

  final Intro? intro;
  String? get _id => intro?.id;

  // * Keys for testing using find.byKey()
  static const introKey = Key('intro');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(introFormProvider(intro));
    final notifier = ref.read(introFormProvider(intro).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text((_id != null) ? 'Edit Intro'.hardcoded : 'New Intro'.hardcoded),
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
            child: TextField(
              controller: TextEditingController(text: state.introText)
                ..selection = TextSelection.collapsed(offset: state.introText.length),
              onChanged: notifier.introTextChanged,
              decoration: InputDecoration(
                labelText: 'Enter Introduction'.hardcoded,
                errorText: state.introError,
              ),
              enabled: !state.isSubmitting,
            ),
          ),
        ),
      ),
    );
  }
}
