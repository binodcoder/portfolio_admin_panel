// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProjectFormState {
  const ProjectFormState({
    this.title = '',
    this.titleError,
    this.description = '',
    this.repoUrl = '',
    this.liveUrl = '',
    this.tags = '',
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String title;
  final String? titleError;
  final String description;
  final String repoUrl;
  final String liveUrl;
  final String tags;
  final bool isSubmitting;
  final bool textChanged;

  ProjectFormState copyWith({
    String? title,
    String? titleError,
    String? description,
    String? repoUrl,
    String? liveUrl,
    String? tags,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return ProjectFormState(
      title: title ?? this.title,
      titleError: titleError,
      description: description ?? this.description,
      repoUrl: repoUrl ?? this.repoUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      tags: tags ?? this.tags,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension ProjectFormStateX on ProjectFormState {
  bool get isValid => title.trim().isNotEmpty && titleError == null;
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
