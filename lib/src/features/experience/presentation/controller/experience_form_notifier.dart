import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_controller.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ExperienceFormNotifier extends StateNotifier<ExperienceFormState> {
  ExperienceFormNotifier(this.ref, Experience? initial)
    : super(
        ExperienceFormState(
          company: initial?.company ?? '',
          title: initial?.title ?? '',
          location: initial?.location ?? '',
          start: initial?.start ?? '',
          end: initial?.end ?? '',
          current: initial?.current ?? false,
          description: initial?.description ?? '',
          technologies: (initial?.technologies ?? const <String>[]).join(', '),
        ),
      ) {
    _validateCompany(state.company);
    _validateTitle(state.title);
  }

  final Ref ref;

  void companyChanged(String value) {
    state = state.copyWith(company: value, textChanged: true);
    _validateCompany(value);
  }

  void _validateCompany(String value) {
    state = state.copyWith(
      companyError: value.trim().isEmpty ? 'Enter company'.hardcoded : null,
    );
  }

  void titleChanged(String value) {
    state = state.copyWith(title: value, textChanged: true);
    _validateTitle(value);
  }

  void _validateTitle(String value) {
    state = state.copyWith(
      titleError: value.trim().isEmpty ? 'Enter title/role'.hardcoded : null,
    );
  }

  void locationChanged(String value) {
    state = state.copyWith(location: value, textChanged: true);
  }

  void startChanged(String value) {
    state = state.copyWith(start: value, textChanged: true);
  }

  void endChanged(String value) {
    if (state.current) return;
    state = state.copyWith(end: value, textChanged: true);
  }

  void currentChanged(bool value) {
    state = state.copyWith(
      current: value,
      end: value ? '' : state.end,
      textChanged: true,
    );
  }

  void descriptionChanged(String value) {
    state = state.copyWith(description: value, textChanged: true);
  }

  void technologiesChanged(String value) {
    state = state.copyWith(technologies: value, textChanged: true);
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);
    final techs = state.technologies
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final data = Experience(
      id: id,
      company: state.company.trim(),
      title: state.title.trim(),
      location: state.location.trim().isEmpty ? null : state.location.trim(),
      start: state.start.trim().isEmpty ? null : state.start.trim(),
      end: state.current
          ? null
          : (state.end.trim().isEmpty ? null : state.end.trim()),
      current: state.current,
      description: state.description.trim().isEmpty ? null : state.description.trim(),
      technologies: techs,
    );
    final controller = ref.read(experienceControllerProvider.notifier);
    final success =
        id == null ? await controller.createExperience(data) : await controller.updateExperience(
          id,
          data,
        );

    state = state.copyWith(isSubmitting: false);
    return success;
  }
}

final experienceFormProvider = StateNotifierProvider.autoDispose
    .family<ExperienceFormNotifier, ExperienceFormState, Experience?>(
      (ref, item) => ExperienceFormNotifier(ref, item),
    );
