import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/responsive_scrollable_card.dart';
import 'package:binodfolioadmin/src/common_widgets/save_button.dart';
import 'package:binodfolioadmin/src/features/about/domain/about.dart';
import 'package:binodfolioadmin/src/features/about/presentation/controller/about_controller.dart';
import 'package:binodfolioadmin/src/features/about/presentation/ui/about_validators.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

class AboutForm extends ConsumerStatefulWidget {
  const AboutForm({super.key, this.about});

  final About? about;

  @override
  ConsumerState<AboutForm> createState() => _AboutFormState();
}

class _AboutFormState extends ConsumerState<AboutForm> with AboutValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _aboutController = TextEditingController();

  String get aboutText => _aboutController.text;

  About? get about => widget.about;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _aboutController.text = widget.about?.value ?? '';
  }

  @override
  void dispose() {
    _node.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(aboutControllerProvider.notifier);

      final success = about == null
          ? await controller.createAbout(value: aboutText)
          : await controller.updateAbout(data: about!, value: aboutText);
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _aboutEditingComplete() {
    if (canSubmitAbout(aboutText)) {
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aboutControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(about != null ? 'Edit About'.hardcoded : 'New About'.hardcoded),
        actions: [
          SaveButton(
            onSave: state.isLoading ? null : () => _submit(),
            isLoading: state.isLoading,
          ),
        ],
      ),
      body: ResponsiveScrollableCard(
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _aboutController,
              decoration: InputDecoration(
                labelText: 'Enter Introduction'.hardcoded,
                enabled: !state.isLoading,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => !_submitted ? null : aboutErrorText(value ?? ''),
              autocorrect: false,
              textInputAction: TextInputAction.done,
              keyboardAppearance: Brightness.light,
              onEditingComplete: () => _aboutEditingComplete(),
            ),
          ),
        ),
      ),
    );
  }
}
