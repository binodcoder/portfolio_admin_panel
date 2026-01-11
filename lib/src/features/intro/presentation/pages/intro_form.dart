import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_scrollable_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/ui/intro_validators.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroForm extends ConsumerStatefulWidget {
  const IntroForm({super.key, this.intro});

  final Intro? intro;

  // * Keys for testing using find.byKey()
  static const introKey = Key('intro');

  @override
  ConsumerState<IntroForm> createState() => _IntroFormState();
}

class _IntroFormState extends ConsumerState<IntroForm> with IntroValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _introController = TextEditingController();

  String get introText => _introController.text;
  String? get _id => widget.intro?.id;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _introController.text = widget.intro?.value ?? '';
  }

  @override
  void dispose() {
    _node.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(introControllerProvider.notifier);
      final data = Intro(id: _id, value: introText.trim());
      final success = _id == null
          ? await controller.createIntro(data)
          : await controller.updateIntro(_id!, data);
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _introEditingComplete() {
    if (canSubmitIntro(introText)) {
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(introControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text((_id != null) ? 'Edit Intro'.hardcoded : 'New Intro'.hardcoded),
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
              key: IntroForm.introKey,
              controller: _introController,
              decoration: InputDecoration(
                labelText: 'Enter Introduction'.hardcoded,
                enabled: !state.isLoading,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => !_submitted ? null : introErrorText(value ?? ''),
              autocorrect: false,
              textInputAction: TextInputAction.done,
              keyboardAppearance: Brightness.light,
              onEditingComplete: () => _introEditingComplete(),
            ),
          ),
        ),
      ),
    );
  }
}
