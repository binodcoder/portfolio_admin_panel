// ignore_for_file: public_member_api_docs, sort_constructors_first
class CertificationFormState {
  const CertificationFormState({
    this.name = '',
    this.nameError,
    this.issuer = '',
    this.issuerError,
    this.issueDate = '',
    this.issueDateError,
    this.expiryDate = '',
    this.expiryDateError,
    this.credentialId = '',
    this.credentialIdError,
    this.credentialUrl = '',
    this.credentialUrlError,
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String name;
  final String? nameError;
  final String issuer;
  final String? issuerError;
  final String issueDate;
  final String? issueDateError;
  final String expiryDate;
  final String? expiryDateError;
  final String credentialId;
  final String? credentialIdError;
  final String credentialUrl;
  final String? credentialUrlError;
  final bool isSubmitting;
  final bool textChanged;

  CertificationFormState copyWith({
    String? name,
    String? nameError,
    String? issuer,
    String? issuerError,
    String? issueDate,
    String? issueDateError,
    String? expiryDate,
    String? expiryDateError,
    String? credentialId,
    String? credentialIdError,
    String? credentialUrl,
    String? credentialUrlError,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return CertificationFormState(
      name: name ?? this.name,
      nameError: nameError ?? this.nameError,
      issuer: issuer ?? this.issuer,
      issuerError: issuerError ?? this.issuerError,
      issueDate: issueDate ?? this.issueDate,
      issueDateError: issueDateError ?? this.issueDateError,
      expiryDate: expiryDate ?? this.expiryDate,
      expiryDateError: expiryDateError ?? this.expiryDateError,
      credentialId: credentialId ?? this.credentialId,
      credentialIdError: credentialIdError ?? this.credentialIdError,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      credentialUrlError: credentialUrlError ?? this.credentialUrlError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension CertificationFormStateX on CertificationFormState {
  bool get isValid =>
      name.trim().isNotEmpty &&
      issuer.trim().isNotEmpty &&
      nameError == null &&
      issuerError == null;

  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
