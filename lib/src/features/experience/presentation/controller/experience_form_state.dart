// ignore_for_file: public_member_api_docs, sort_constructors_first

class ExperienceFormState {
  const ExperienceFormState({
    this.company = '',
    this.companyError,
    this.title = '',
    this.titleError,
    this.location = '',
    this.start = '',
    this.end = '',
    this.current = false,
    this.description = '',
    this.technologies = '',
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String company;
  final String? companyError;
  final String title;
  final String? titleError;
  final String location;
  final String start;
  final String end;
  final bool current;
  final String description;
  final String technologies;
  final bool isSubmitting;
  final bool textChanged;

  ExperienceFormState copyWith({
    String? company,
    String? companyError,
    String? title,
    String? titleError,
    String? location,
    String? start,
    String? end,
    bool? current,
    String? description,
    String? technologies,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return ExperienceFormState(
      company: company ?? this.company,
      companyError: companyError,
      title: title ?? this.title,
      titleError: titleError,
      location: location ?? this.location,
      start: start ?? this.start,
      end: end ?? this.end,
      current: current ?? this.current,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension ExperienceFormStateX on ExperienceFormState {
  bool get isValid =>
      company.trim().isNotEmpty && title.trim().isNotEmpty && companyError == null && titleError == null;
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
