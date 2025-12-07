import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';

class AboutForm extends ConsumerStatefulWidget {
  const AboutForm({super.key, this.item});
  final About? item;
  @override
  ConsumerState<AboutForm> createState() => _AboutFormState();
}

class _AboutFormState extends ConsumerState<AboutForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) textController.text = widget.item!.value;
    // Rebuild when text changes so Save button updates
    textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final text = textController.text.trim();
    final notifier = ref.read(aboutControllerProvider.notifier);
    if (_id == null) {
      await notifier.createAbout(About(value: text));
    } else {
      await notifier.updateAbout(_id!, About(value: text));
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(aboutControllerProvider);
    final canSave = !async.isLoading && textController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit About' : 'New About'),
        actions: [
          TextButton.icon(
            onPressed: canSave ? _save : null,
            icon: async.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_outlined),
            label: const Text('Save'),
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
                  child: Column(
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
                        controller: textController,
                        minLines: 6,
                        maxLines: null,
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? 'Please enter about text' : null,
                        decoration: const InputDecoration(
                          hintText: 'Tell us about yourself',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
