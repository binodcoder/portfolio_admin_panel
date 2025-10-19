import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/social_controller.dart';

class SocialForm extends ConsumerStatefulWidget {
  const SocialForm({super.key, this.item});
  final SocialLink? item;

  @override
  ConsumerState<SocialForm> createState() => _SocialFormState();
}

class _SocialFormState extends ConsumerState<SocialForm> {
  final _formKey = GlobalKey<FormState>();
  final platformController = TextEditingController();
  final urlController = TextEditingController();

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final s = widget.item;
    if (s != null) {
      platformController.text = s.platform;
      urlController.text = s.url;
    }
  }

  @override
  void dispose() {
    platformController.dispose();
    urlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = SocialLink(id: _id, platform: platformController.text.trim(), url: urlController.text.trim());
    final notifier = ref.read(socialActionControllerProvider.notifier);
    if (_id == null) {
      await notifier.createSocial(data);
    } else {
      await notifier.updateSocial(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(socialActionControllerProvider);
    final canSave = !async.isLoading && platformController.text.trim().isNotEmpty && urlController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Link' : 'New Link'),
        actions: [
          TextButton.icon(
            onPressed: canSave ? _save : null,
            icon: async.isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
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
                      TextFormField(
                        controller: platformController,
                        validator: (v) => (v ?? '').trim().isEmpty ? 'Enter platform name' : null,
                        decoration: const InputDecoration(labelText: 'Platform (e.g. GitHub, LinkedIn)'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: urlController,
                        validator: (v) => (v ?? '').trim().isEmpty ? 'Enter URL' : null,
                        decoration: const InputDecoration(labelText: 'URL'),
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
