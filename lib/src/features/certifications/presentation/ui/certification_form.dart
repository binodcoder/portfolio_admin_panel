import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/responsive_scrollable_card.dart';
import 'package:binodfolioadmin/src/common_widgets/save_button.dart';
import 'package:binodfolioadmin/src/constants/app_sizes.dart';
import 'package:binodfolioadmin/src/features/certifications/domain/certification.dart';
import 'package:binodfolioadmin/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:binodfolioadmin/src/features/certifications/presentation/ui/certification_validators.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

class CertificationForm extends ConsumerStatefulWidget {
  const CertificationForm({super.key, this.item});
  final Certification? item;

  @override
  ConsumerState<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends ConsumerState<CertificationForm>
    with CertificationValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _nameController = TextEditingController();
  final _issuerController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _credentialUrlController = TextEditingController();

  String _credentialId = '';

  String get name => _nameController.text.trim();
  String get issuer => _issuerController.text.trim();
  String get issueDate => _issueDateController.text.trim();
  String get expiryDate => _expiryDateController.text.trim();
  String get credentialUrl => _credentialUrlController.text.trim();

  Certification? get certification => widget.item;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item?.name ?? '';
    _issuerController.text = widget.item?.issuer ?? '';
    _issueDateController.text = widget.item?.issueDate == null
        ? ''
        : _formatDate(widget.item!.issueDate!);
    _expiryDateController.text = widget.item?.expiryDate == null
        ? ''
        : _formatDate(widget.item!.expiryDate!);
    _credentialUrlController.text = widget.item?.credentialUrl ?? '';
    _credentialId = widget.item?.credentialId ?? '';
  }

  @override
  void dispose() {
    _node.dispose();
    _nameController.dispose();
    _issuerController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _credentialUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(certificationControllerProvider.notifier);

      final success = certification == null
          ? await controller.createCertification(
              name: name,
              issuer: issuer,
              issueDate: issueDate,
              expiryDate: expiryDate,
              credentialId: _credentialId,
              credentialUrl: credentialUrl,
            )
          : await controller.updateCertification(
              data: certification!,
              name: name,
              issuer: issuer,
              issueDate: issueDate,
              expiryDate: expiryDate,
              credentialId: _credentialId,
              credentialUrl: credentialUrl,
            );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _nameEditingComplete() {
    if (canSubmitName(name)) {
      _node.nextFocus();
    }
  }

  void _issuerEditingComplete() {
    if (canSubmitIssuer(issuer)) {
      _node.nextFocus();
    }
  }

  void _issueDateEditingComplete() {
    if (canSubmitIssueDate(issueDate)) {
      _node.nextFocus();
    }
  }

  void _expiryDateEditingComplete() {
    if (canSubmitExpiryDate(expiryDate)) {
      _node.nextFocus();
    }
  }

  void _credentialUrlEditingComplete() {
    if (canSubmitCredentialUrl(credentialUrl)) {
      _submit();
    }
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

  DateTime _initialDate(String value) =>
      DateTime.tryParse(value.trim()) ?? DateTime.now();

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _initialDate(controller.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = _formatDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(certificationControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(certification != null ? 'Edit Certification' : 'New Certification'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => !_submitted ? null : nameErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _nameEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _issuerController,
                  decoration: InputDecoration(
                    labelText: 'Issuer (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => !_submitted ? null : issuerErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _issuerEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _issueDateController,
                  decoration: InputDecoration(
                    labelText: 'Issue Date'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : issueDateErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  readOnly: true,
                  onTap: state.isLoading ? null : () => _selectDate(_issueDateController),
                  onEditingComplete: () => _issueDateEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : expiryDateErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  readOnly: true,
                  onTap: state.isLoading
                      ? null
                      : () => _selectDate(_expiryDateController),
                  onEditingComplete: () => _expiryDateEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _credentialUrlController,
                  decoration: InputDecoration(
                    labelText: 'Credential URL (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : credentialUrlErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.url,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _credentialUrlEditingComplete(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
