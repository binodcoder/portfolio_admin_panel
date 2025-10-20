import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';

class CertificationForm extends ConsumerStatefulWidget {
  const CertificationForm({super.key, this.item});
  final Certification? item;
  @override
  ConsumerState<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends ConsumerState<CertificationForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final issuerController = TextEditingController();
  final issueDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  final credentialIdController = TextEditingController();
  final credentialUrlController = TextEditingController();

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final c = widget.item;
    if (c != null) {
      nameController.text = c.name;
      issuerController.text = c.issuer ?? '';
      issueDateController.text = c.issueDate ?? '';
      expiryDateController.text = c.expiryDate ?? '';
      credentialIdController.text = c.credentialId ?? '';
      credentialUrlController.text = c.credentialUrl ?? '';
    }
    // Rebuild when fields change so Save button updates
    nameController.addListener(() => setState(() {}));
    issuerController.addListener(() => setState(() {}));
    issueDateController.addListener(() => setState(() {}));
    expiryDateController.addListener(() => setState(() {}));
    credentialIdController.addListener(() => setState(() {}));
    credentialUrlController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    issuerController.dispose();
    issueDateController.dispose();
    expiryDateController.dispose();
    credentialIdController.dispose();
    credentialUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = Certification(
      id: _id,
      name: nameController.text.trim(),
      issuer: issuerController.text.trim().isEmpty ? null : issuerController.text.trim(),
      issueDate: issueDateController.text.trim().isEmpty
          ? null
          : issueDateController.text.trim(),
      expiryDate: expiryDateController.text.trim().isEmpty
          ? null
          : expiryDateController.text.trim(),
      credentialId: credentialIdController.text.trim().isEmpty
          ? null
          : credentialIdController.text.trim(),
      credentialUrl: credentialUrlController.text.trim().isEmpty
          ? null
          : credentialUrlController.text.trim(),
    );
    final notifier = ref.read(certificationsActionControllerProvider.notifier);
    if (_id == null) {
      await notifier.createCertification(data);
    } else {
      await notifier.updateCertification(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(certificationsActionControllerProvider);
    final canSave = !async.isLoading && nameController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Certification' : 'New Certification'),
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
                        controller: nameController,
                        validator: (v) => (v ?? '').trim().isEmpty ? 'Enter name' : null,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: issuerController,
                              decoration: const InputDecoration(
                                labelText: 'Issuer (optional)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: issueDateController,
                              decoration: const InputDecoration(
                                labelText: 'Issue (YYYY-MM)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: expiryDateController,
                              decoration: const InputDecoration(
                                labelText: 'Expiry (YYYY-MM, optional)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: credentialIdController,
                              decoration: const InputDecoration(
                                labelText: 'Credential ID (optional)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: credentialUrlController,
                              decoration: const InputDecoration(
                                labelText: 'Credential URL (optional)',
                              ),
                            ),
                          ),
                        ],
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
