import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/about/data/about_repository.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';

class AboutForm extends ConsumerStatefulWidget {
  const AboutForm({super.key});

  @override
  ConsumerState<AboutForm> createState() => _AboutFormState();
}

class _AboutFormState extends ConsumerState<AboutForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController textController;
  late final String? currentId;
  late final bool isEditing;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController()..addListener(() => setState(() {}));

    final first = ref.read(aboutListProvider).asData?.value.firstOrNull;
    if (first != null) {
      textController.text = first.value;
      currentId = first.id;
      isEditing = currentId != null;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final router = GoRouter.of(context);

    final notifier = ref.read(aboutControllerProvider.notifier);
    final text = textController.text.trim();

    final success = currentId == null
        ? await notifier.createAbout(About(value: text))
        : await notifier.updateAbout(currentId!, About(id: currentId, value: text));

    if (success) router.pop();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(aboutControllerProvider);

    final canSave = !controllerState.isLoading && textController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit About' : 'New About'),
        actions: [
          _SaveButton(
            isLoading: controllerState.isLoading,
            canSave: canSave,
            onSave: _submit,
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _AboutTextField(controller: textController),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isLoading,
    required this.canSave,
    required this.onSave,
  });

  final bool isLoading;
  final bool canSave;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: canSave ? onSave : null,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check_outlined),
      label: const Text('Save'),
    );
  }
}

class _AboutTextField extends StatelessWidget {
  const _AboutTextField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          minLines: 6,
          maxLines: null,
          validator: (v) => (v ?? '').trim().isEmpty ? 'Please enter about text' : null,
          decoration: const InputDecoration(hintText: 'Tell us about yourself'),
        ),
      ],
    );
  }
}
