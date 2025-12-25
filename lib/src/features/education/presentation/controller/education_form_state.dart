// ignore_for_file: public_member_api_docs, sort_constructors_first

class EducationFormState {
  const EducationFormState({
    this.institution = '',
    this.institutionError,
    this.degree = '',
    this.field = '',
    this.start = '',
    this.end = '',
    this.location = '',
    this.gpa = '',
    this.description = '',
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String institution;
  final String? institutionError;
  final String degree;
  final String field;
  final String start;
  final String end;
  final String location;
  final String gpa;
  final String description;
  final bool isSubmitting;
  final bool textChanged;

  EducationFormState copyWith({
    String? institution,
    String? institutionError,
    String? degree,
    String? field,
    String? start,
    String? end,
    String? location,
    String? gpa,
    String? description,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return EducationFormState(
      institution: institution ?? this.institution,
      institutionError: institutionError,
      degree: degree ?? this.degree,
      field: field ?? this.field,
      start: start ?? this.start,
      end: end ?? this.end,
      location: location ?? this.location,
      gpa: gpa ?? this.gpa,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension EducationFormStateX on EducationFormState {
  bool get isValid => institution.trim().isNotEmpty && institutionError == null;
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
