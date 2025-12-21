class SocialFormState {
  const SocialFormState({this.platform = '', this.url = '', this.isSubmitting = false});

  final String platform;
  final String url;
  final bool isSubmitting;

  bool get isValid => platform.trim().isNotEmpty && url.trim().isNotEmpty;

  SocialFormState copyWith({String? platform, String? url, bool? isSubmitting}) {
    return SocialFormState(
      platform: platform ?? this.platform,
      url: url ?? this.url,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
