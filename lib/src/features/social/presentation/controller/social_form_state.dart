class SocialFormState {
  const SocialFormState({
    this.platform = '',
    this.url = '',
    this.platformError,
    this.urlError,
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String platform;
  final String url;

  final String? platformError;
  final String? urlError;

  final bool isSubmitting;
  final bool textChanged;

  SocialFormState copyWith({
    String? platform,
    String? url,
    String? platformError,
    String? urlError,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return SocialFormState(
      platform: platform ?? this.platform,
      url: url ?? this.url,
      platformError: platformError,
      urlError: urlError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension SocialFormStateX on SocialFormState {
  bool get isValid =>
      platformError == null &&
      urlError == null &&
      platform.trim().isNotEmpty &&
      url.trim().isNotEmpty;

  bool get showErrorMessages => platformError != null || urlError != null;

  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
