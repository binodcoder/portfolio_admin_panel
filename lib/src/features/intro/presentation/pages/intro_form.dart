import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_dialogs.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroForm extends ConsumerStatefulWidget {
  const IntroForm({super.key, this.introId});
  final String? introId;

  @override
  ConsumerState<IntroForm> createState() => _IntroFormState();
}

class _IntroFormState extends ConsumerState<IntroForm> {
  final _formKey = GlobalKey<FormState>();
  final _introTextController = TextEditingController();
  bool _hasPrefilled = false;

  @override
  void dispose() {
    _introTextController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final text = _introTextController.text.trim();
    final notifier = ref.read(introActionControllerProvider.notifier);

    await notifier.upsertIntro(Intro(value: text));

    if (!mounted) return;

    final actionState = ref.read(introActionControllerProvider);
    if (actionState.hasError) {
      final err = actionState.error;
      IntroDialogs.showSnack(context, 'Failed to save: $err'.hardcoded);
      return;
    }

    // Success handled by IntroPage listener; just pop
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(introActionControllerProvider);
    final introAsync = ref.watch(introControllerProvider);

    // Prefill from the single intro doc once
    final existing = introAsync.asData?.value;
    if (!_hasPrefilled && existing != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _introTextController.text = existing.value;
        setState(() {
          _hasPrefilled = true;
        });
      });
    }

    final isSaving = actionState.isLoading;
    final trimmed = _introTextController.text.trim();
    final hasContent = trimmed.isNotEmpty;
    final existingText = existing?.value ?? '';
    final hasChanges = trimmed != existingText.trim();
    final isSaveEnabled = !isSaving && hasContent && hasChanges;

    return Scaffold(
      appBar: AppBar(
        title: Text((existing != null) ? 'Edit Intro'.hardcoded : 'New Intro'.hardcoded),
        actions: [
          _SaveButton(onPressed: isSaveEnabled ? _save : null, isLoading: isSaving),
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
              child: _IntroFormCard(
                isEditing: existing != null,
                controller: _introTextController,
                isLoading: isSaving,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroFormCard extends StatelessWidget {
  const _IntroFormCard({
    required this.isEditing,
    required this.controller,
    required this.isLoading,
    required this.onChanged,
  });

  final bool isEditing;
  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introduction'.hardcoded,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              'This appears on your portfolio landing page.'.hardcoded,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            gapH20,
            TextFormField(
              controller: controller,
              minLines: 6,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              enabled: !isLoading,
              onChanged: onChanged,
              validator: (value) => (value ?? '').trim().isEmpty
                  ? 'Please enter an introduction'.hardcoded
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText:
                    "E.g. I'm a Flutter developer building delightful apps.".hardcoded,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check_outlined),
      label: Text('Save'.hardcoded),
    );
  }
}
