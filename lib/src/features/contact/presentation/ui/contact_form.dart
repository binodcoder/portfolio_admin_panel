import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_controller.dart';

class ContactForm extends ConsumerStatefulWidget {
  const ContactForm({super.key, this.item});
  final ContactInfo? item;
  @override
  ConsumerState<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final messageController = TextEditingController();
  bool openToWork = true;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final c = widget.item;
    if (c != null) {
      emailController.text = c.email ?? '';
      phoneController.text = c.phone ?? '';
      locationController.text = c.location ?? '';
      websiteController.text = c.website ?? '';
      messageController.text = c.message ?? '';
      openToWork = c.openToWork;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    websiteController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = ContactInfo(
      id: _id,
      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
      location: locationController.text.trim().isEmpty
          ? null
          : locationController.text.trim(),
      website: websiteController.text.trim().isEmpty
          ? null
          : websiteController.text.trim(),
      openToWork: openToWork,
      message: messageController.text.trim().isEmpty
          ? null
          : messageController.text.trim(),
    );
    final notifier = ref.read(contactControllerProvider.notifier);
    if (_id == null) {
      await notifier.createContact(data);
    } else {
      await notifier.updateContact(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(contactControllerProvider);
    final canSave = !async.isLoading; // all fields optional
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'New Contact'),
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
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(labelText: 'Phone'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: locationController,
                              decoration: const InputDecoration(labelText: 'Location'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: websiteController,
                        decoration: const InputDecoration(labelText: 'Website'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Switch(
                            value: openToWork,
                            onChanged: (v) => setState(() => openToWork = v),
                          ),
                          const SizedBox(width: 8),
                          const Text('Open to work'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: messageController,
                        minLines: 3,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Contact message (optional)',
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
