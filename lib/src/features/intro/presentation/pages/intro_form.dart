import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
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
  String? _initialText;

  bool get _isEditMode => widget.introId != null && widget.introId != 'new';
  String? get _editingIntroId => _isEditMode ? widget.introId : null;

  @override
  void dispose() {
    _introTextController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final text = _introTextController.text.trim();
    final notifier = ref.read(introActionControllerProvider.notifier);

    if (_isEditMode) {
      await notifier.updateIntro(_editingIntroId!, Intro(value: text));
    } else {
      await notifier.createIntro(Intro(value: text));
    }

    if (!mounted) return;

    final actionState = ref.read(introActionControllerProvider);
    if (actionState.hasError) {
      final err = actionState.error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $err'.hardcoded)));
      return;
    }

    // Success
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved'.hardcoded)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(introActionControllerProvider);
    final isSaving = actionState.isLoading;
    final trimmed = _introTextController.text.trim();
    final hasContent = trimmed.isNotEmpty;
    final hasChanges = !_isEditMode || (trimmed != (_initialText ?? '').trim());
    final isSaveEnabled = !isSaving && hasContent && hasChanges;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Intro'.hardcoded : 'New Intro'.hardcoded),
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
                isEditing: _isEditMode,
                editingIntroId: _editingIntroId,
                controller: _introTextController,
                hasPrefilled: _hasPrefilled,
                onPrefilled: (value) => setState(() {
                  _hasPrefilled = true;
                  _initialText = value;
                }),
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
    required this.editingIntroId,
    required this.controller,
    required this.hasPrefilled,
    required this.onPrefilled,
    required this.isLoading,
    required this.onChanged,
  });

  final bool isEditing;
  final String? editingIntroId;
  final TextEditingController controller;
  final bool hasPrefilled;
  final ValueChanged<String> onPrefilled;
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
            if (isEditing && editingIntroId != null)
              _IntroPrefillLoader(
                introId: editingIntroId!,
                textController: controller,
                hasPrefilled: hasPrefilled,
                onPrefilled: onPrefilled,
              ),
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

class _IntroPrefillLoader extends ConsumerWidget {
  const _IntroPrefillLoader({
    required this.introId,
    required this.textController,
    required this.hasPrefilled,
    required this.onPrefilled,
  });

  final String introId;
  final TextEditingController textController;
  final bool hasPrefilled;
  final ValueChanged<String> onPrefilled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introAsync = ref.watch(introByIdProvider(introId));

    return introAsync.when(
      loading: () => hasPrefilled
          ? const SizedBox.shrink()
          : const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LinearProgressIndicator(),
            ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          'Failed to load intro: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
      data: (intro) {
        if (!hasPrefilled && intro != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            textController.text = intro.value;
            onPrefilled(intro.value);
          });
        }
        return const SizedBox.shrink();
      },
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
