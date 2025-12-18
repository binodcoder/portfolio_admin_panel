import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/widgets/custom_text_form_field.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class CertificationForm extends ConsumerStatefulWidget {
  const CertificationForm({super.key, this.item});
  final Certification? item;
  @override
  ConsumerState<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends ConsumerState<CertificationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _issuerController;
  late final TextEditingController _issueDateController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _credentialIdController;
  late final TextEditingController _credentialUrlController;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final Certification? certification = widget.item;
    _nameController = TextEditingController(text: certification?.name);
    _issuerController = TextEditingController(text: certification?.issuer);
    _issueDateController = TextEditingController(text: certification?.issueDate);
    _expiryDateController = TextEditingController(text: certification?.expiryDate);
    _credentialIdController = TextEditingController(text: certification?.expiryDate);
    _credentialUrlController = TextEditingController(text: certification?.credentialUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _credentialIdController.dispose();
    _credentialUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = Certification(
      id: _id,
      name: _nameController.text.trim(),
      issuer: _issuerController.text.trim().isEmpty
          ? null
          : _issuerController.text.trim(),
      issueDate: _issueDateController.text.trim().isEmpty
          ? null
          : _issueDateController.text.trim(),
      expiryDate: _expiryDateController.text.trim().isEmpty
          ? null
          : _expiryDateController.text.trim(),
      credentialId: _credentialIdController.text.trim().isEmpty
          ? null
          : _credentialIdController.text.trim(),
      credentialUrl: _credentialUrlController.text.trim().isEmpty
          ? null
          : _credentialUrlController.text.trim(),
    );
    final notifier = ref.read(certificationControllerProvider.notifier);
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
    final async = ref.watch(certificationControllerProvider);
    //  final canSave = !async.isLoading && _nameController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Certification' : 'New Certification'),
        actions: [
          TextButton.icon(
            onPressed: _save,
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
      body: ResponsiveCenter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4, vertical: Sizes.p24),
          child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: 'Name'.hardcoded,
                      validator: (v) => (v ?? '').trim().isEmpty ? 'Enter name' : null,
                    ),

                    gapH12,
                    CustomTextFormField(
                      controller: _issuerController,
                      labelText: 'Issuer (optional)'.hardcoded,
                    ),

                    gapH12,

                    CustomTextFormField(
                      controller: _issueDateController,
                      labelText: 'Issue (YYYY-MM)'.hardcoded,
                    ),

                    gapH12,
                    CustomTextFormField(
                      controller: _expiryDateController,
                      labelText: 'Expiry (YYYY-MM, optional)'.hardcoded,
                    ),
                    gapH12,
                    CustomTextFormField(
                      controller: _credentialUrlController,
                      labelText: 'Credential URL (optional)'.hardcoded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
