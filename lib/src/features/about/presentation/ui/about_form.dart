import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/form_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class AboutForm extends ConsumerStatefulWidget {
  const AboutForm({super.key, this.about});

  final About? about;

  @override
  ConsumerState<AboutForm> createState() => _AboutFormState();
}

class _AboutFormState extends ConsumerState<AboutForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController aboutController;

  @override
  void initState() {
    super.initState();
    aboutController = TextEditingController(
      text: widget.about?.value.trim() ?? ''.trim(),
    );
  }

  @override
  void dispose() {
    aboutController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    final initial = widget.about?.value.trim() ?? '';
    ref.read(aboutCanSaveProvider.notifier).state = initial != value;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final goRouter = GoRouter.of(context);

    FocusScope.of(context).unfocus();
    final aboutText = aboutController.text;

    final notifier = ref.read(aboutControllerProvider.notifier);

    final aboutId = widget.about?.id;

    final success = widget.about == null
        ? await notifier.createAbout(About(value: aboutText))
        : await notifier.updateAbout(aboutId!, About(id: aboutId, value: aboutText));

    if (success && mounted) {
      goRouter.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSave = ref.watch(aboutCanSaveProvider);
    final bool isLoading = (ref.watch(
      aboutControllerProvider.select((s) => s.isLoading),
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.about != null ? 'Edit About'.hardcoded : 'New About'.hardcoded,
        ),
        actions: [
          SaveButton(
            onSave: (canSave && !isLoading) ? _submit : null,
            isLoading: isLoading,
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
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: FormCard(
                title: 'About'.hardcoded,
                subTitle: 'This appears on your portfolio about section'.hardcoded,
                controller: aboutController,
                onChanged: _onTextChanged,
                isLoading: isLoading,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
