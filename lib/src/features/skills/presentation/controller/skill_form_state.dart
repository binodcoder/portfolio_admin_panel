// ignore_for_file: public_member_api_docs, sort_constructors_first

class SkillFormState {
  const SkillFormState({
    this.name = '',
    this.nameError,
    this.category = '',
    this.level = 50,
    this.isSubmitting = false,
    this.textChanged = false,
  });

  final String name;
  final String? nameError;
  final String category;
  final double level;
  final bool isSubmitting;
  final bool textChanged;

  SkillFormState copyWith({
    String? name,
    String? nameError,
    String? category,
    double? level,
    bool? isSubmitting,
    bool? textChanged,
  }) {
    return SkillFormState(
      name: name ?? this.name,
      nameError: nameError,
      category: category ?? this.category,
      level: level ?? this.level,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      textChanged: textChanged ?? this.textChanged,
    );
  }
}

extension SkillFormStateX on SkillFormState {
  bool get isValid => name.trim().isNotEmpty && nameError == null;
  bool get canSubmit => isValid && !isSubmitting && textChanged;
}
