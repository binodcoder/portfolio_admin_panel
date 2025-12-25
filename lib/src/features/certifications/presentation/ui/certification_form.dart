import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certification_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certification_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class CertificationForm extends ConsumerWidget {
  const CertificationForm({super.key, this.item});
  final Certification? item;

  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(certificationFormProvider(item));
    final notifier = ref.read(certificationFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Certification' : 'New Certification'),
        actions: [
          SaveButton(
            onSave: !state.canSubmit
                ? null
                : () async {
                    final success = await notifier.submit(id: _id);
                    if (context.mounted && success) {
                      context.pop();
                    }
                  },
            isLoading: state.isSubmitting,
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4, vertical: Sizes.p24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: TextEditingController(text: state.name)
                      ..selection = TextSelection.collapsed(offset: state.name.length),
                    onChanged: notifier.nameTextChanged,
                    labelText: 'Name'.hardcoded,
                    errorText: state.nameError,
                    enabled: !state.isSubmitting,
                  ),
                  gapH12,
                  CustomTextField(
                    controller: TextEditingController(text: state.issuer)
                      ..selection = TextSelection.collapsed(offset: state.issuer.length),
                    onChanged: notifier.issuerTextChanged,
                    labelText: 'Issuer (optional)'.hardcoded,
                    errorText: state.issuerError,
                    enabled: !state.isSubmitting,
                  ),
                  gapH12,
                  CustomTextField(
                    controller: TextEditingController(text: state.issueDate)
                      ..selection = TextSelection.collapsed(
                        offset: state.issueDate.length,
                      ),
                    onChanged: notifier.issueDateTextChanged,
                    labelText: 'Issue (YYYY-MM)'.hardcoded,
                    errorText: state.issueDateError,
                    enabled: !state.isSubmitting,
                  ),
                  gapH12,
                  CustomTextField(
                    controller: TextEditingController(text: state.expiryDate)
                      ..selection = TextSelection.collapsed(
                        offset: state.expiryDate.length,
                      ),
                    onChanged: notifier.exparyDateTextChanged,
                    labelText: 'Expiry (YYYY-MM, optional)'.hardcoded,
                    errorText: state.expiryDateError,
                    enabled: !state.isSubmitting,
                  ),
                  gapH12,
                  CustomTextField(
                    controller: TextEditingController(text: state.credentialUrl)
                      ..selection = TextSelection.collapsed(
                        offset: state.credentialUrl.length,
                      ),
                    onChanged: notifier.credentialUrlChanged,
                    labelText: 'Credential URL (optional)'.hardcoded,
                    errorText: state.credentialUrlError,
                    enabled: !state.isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
