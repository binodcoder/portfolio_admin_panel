import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_controller.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class EducationFormNotifier extends StateNotifier<EducationFormState> {
  EducationFormNotifier(this.ref, Education? initial)
    : super(
        EducationFormState(
          institution: initial?.institution ?? '',
          degree: initial?.degree ?? '',
          field: initial?.field ?? '',
          start: initial?.start ?? '',
          end: initial?.end ?? '',
          location: initial?.location ?? '',
          gpa: initial?.gpa ?? '',
          description: initial?.description ?? '',
        ),
      ) {
    _validateInstitution(state.institution);
  }

  final Ref ref;

  void institutionChanged(String value) {
    state = state.copyWith(institution: value, textChanged: true);
    _validateInstitution(value);
  }

  void _validateInstitution(String value) {
    state = state.copyWith(
      institutionError: value.trim().isEmpty ? 'Enter institution'.hardcoded : null,
    );
  }

  void degreeChanged(String value) {
    state = state.copyWith(degree: value, textChanged: true);
  }

  void fieldChanged(String value) {
    state = state.copyWith(field: value, textChanged: true);
  }

  void startChanged(String value) {
    state = state.copyWith(start: value, textChanged: true);
  }

  void endChanged(String value) {
    state = state.copyWith(end: value, textChanged: true);
  }

  void locationChanged(String value) {
    state = state.copyWith(location: value, textChanged: true);
  }

  void gpaChanged(String value) {
    state = state.copyWith(gpa: value, textChanged: true);
  }

  void descriptionChanged(String value) {
    state = state.copyWith(description: value, textChanged: true);
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);
    final data = Education(
      id: id,
      institution: state.institution.trim(),
      degree: state.degree.trim().isEmpty ? null : state.degree.trim(),
      field: state.field.trim().isEmpty ? null : state.field.trim(),
      start: state.start.trim().isEmpty ? null : state.start.trim(),
      end: state.end.trim().isEmpty ? null : state.end.trim(),
      location: state.location.trim().isEmpty ? null : state.location.trim(),
      gpa: state.gpa.trim().isEmpty ? null : state.gpa.trim(),
      description: state.description.trim().isEmpty ? null : state.description.trim(),
    );
    final controller = ref.read(educationControllerProvider.notifier);
    final success =
        id == null ? await controller.createEducation(data) : await controller.updateEducation(
          id,
          data,
        );

    state = state.copyWith(isSubmitting: false);
    return success;
  }
}

final educationFormProvider = StateNotifierProvider.autoDispose
    .family<EducationFormNotifier, EducationFormState, Education?>(
      (ref, item) => EducationFormNotifier(ref, item),
    );
