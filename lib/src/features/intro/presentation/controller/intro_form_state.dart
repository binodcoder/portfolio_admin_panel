// ignore_for_file: public_member_api_docs, sort_constructors_first
class IntroFormState {
  const IntroFormState({
    this.introText = '',
    this.introError,
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String introText;
  final String? introError;
  final bool isSubmitting;
  final bool textChanged;

  IntroFormState copyWith({
    String? introText,
    String? introError,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return IntroFormState(
      introText: introText ?? this.introText,
      introError: introError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension IntroFormStateX on IntroFormState {
  bool get isValid => introText.trim().isNotEmpty && introError == null;
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
