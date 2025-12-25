// ignore_for_file: public_member_api_docs, sort_constructors_first
class AboutFormState {
  const AboutFormState({
    this.aboutText = '',
    this.aboutError,
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String aboutText;
  final String? aboutError;
  final bool isSubmitting;
  final bool textChanged;

  AboutFormState copyWith({
    String? aboutText,
    String? aboutError,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return AboutFormState(
      aboutText: aboutText ?? this.aboutText,
      aboutError: aboutError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension AboutFormStateX on AboutFormState {
  bool get isValid => aboutText.trim().isNotEmpty && aboutError == null;
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
