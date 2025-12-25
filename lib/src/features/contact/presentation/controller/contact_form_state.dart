// ignore_for_file: public_member_api_docs, sort_constructors_first

class ContactFormState {
  const ContactFormState({
    this.email = '',
    this.phone = '',
    this.location = '',
    this.website = '',
    this.message = '',
    this.openToWork = true,
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String email;
  final String phone;
  final String location;
  final String website;
  final String message;
  final bool openToWork;
  final bool isSubmitting;
  final bool textChanged;

  ContactFormState copyWith({
    String? email,
    String? phone,
    String? location,
    String? website,
    String? message,
    bool? openToWork,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return ContactFormState(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      website: website ?? this.website,
      message: message ?? this.message,
      openToWork: openToWork ?? this.openToWork,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension ContactFormStateX on ContactFormState {
  bool get isValid => true; // contact fields are optional
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
