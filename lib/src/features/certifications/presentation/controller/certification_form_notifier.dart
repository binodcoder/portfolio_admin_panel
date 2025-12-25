import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certification_form_state.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class CertificationFormNotifier extends StateNotifier<CertificationFormState> {
  CertificationFormNotifier(this.ref, Certification? initialValue)
    : super(
        CertificationFormState(
          name: initialValue?.name ?? '',
          issuer: initialValue?.issuer ?? '',
          issueDate: initialValue?.issueDate ?? '',
          expiryDate: initialValue?.expiryDate ?? '',
          credentialId: initialValue?.credentialId ?? '',
          credentialUrl: initialValue?.credentialUrl ?? '',
        ),
      ) {
    _validateAll();
  }
  final Ref ref;

  void nameTextChanged(String value) {
    state = state.copyWith(name: value, textChanged: true);
  }

  void _validateNameText(String value) {
    state = state.copyWith(
      nameError: value.trim().isEmpty ? 'Enter Name'.hardcoded : null,
    );
  }

  void issuerTextChanged(String value) {
    state = state.copyWith(issuer: value, textChanged: true);
  }

  void _validateIssuer(String value) {
    state = state.copyWith(
      issuerError: value.trim().isEmpty ? 'Enter issuer'.hardcoded : null,
    );
  }

  void issueDateTextChanged(String value) {
    state = state.copyWith(issueDate: value, textChanged: true);
  }

  void _validateIssueDate(String value) {
    state = state.copyWith(
      issueDateError: value.trim().isEmpty ? 'Enter issue date'.hardcoded : null,
    );
  }

  void exparyDateTextChanged(String value) {
    state = state.copyWith(expiryDate: value, textChanged: true);
  }

  void _validateExpiryDate(String value) {
    state = state.copyWith(
      expiryDateError: value.trim().isEmpty ? 'Enter expiry date'.hardcoded : null,
    );
  }

  void credentialIdChanged(String value) {
    state = state.copyWith(credentialId: value, textChanged: true);
  }

  void _validateCredentialId(String value) {
    state = state.copyWith(
      credentialIdError: value.trim().isEmpty ? 'Enter credential id'.hardcoded : null,
    );
  }

  void credentialUrlChanged(String value) {
    state = state.copyWith(credentialUrl: value, textChanged: true);
  }

  void _validateCredentialUrl(String value) {
    state = state.copyWith(
      credentialUrlError: value.trim().isEmpty ? 'Enter credential Url'.hardcoded : null,
    );
  }

  void _validateAll() {
    _validateNameText(state.name);
    _validateIssuer(state.issuer);
    _validateIssueDate(state.issueDate);
    _validateExpiryDate(state.expiryDate);
    _validateCredentialId(state.credentialId);
    _validateCredentialUrl(state.credentialUrl);
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);
    final data = Certification(
      id: id,
      name: state.name.trim(),
      issuer: state.issuer.trim(),
      issueDate: state.issueDate.trim(),
      expiryDate: state.expiryDate.trim(),
      credentialId: state.credentialId.trim(),
      credentialUrl: state.credentialUrl.trim(),
    );
    final certificationController = ref.read(certificationControllerProvider.notifier);
    final result = id == null
        ? await certificationController.createCertification(data)
        : await certificationController.updateCertification(id, data);

    state = state.copyWith(isSubmitting: false);
    return result;
  }
}

final certificationFormProvider = StateNotifierProvider.autoDispose
    .family<CertificationFormNotifier, CertificationFormState, Certification?>((
      ref,
      item,
    ) {
      return CertificationFormNotifier(ref, item);
    });
