import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/projects_controller.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/project_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ProjectFormNotifier extends StateNotifier<ProjectFormState> {
  ProjectFormNotifier(this.ref, Project? initial)
    : super(
        ProjectFormState(
          title: initial?.title ?? '',
          description: initial?.description ?? '',
          repoUrl: initial?.repoUrl ?? '',
          liveUrl: initial?.liveUrl ?? '',
          tags: (initial?.tags ?? const <String>[]).join(', '),
        ),
      ) {
    _validateTitle(state.title);
  }

  final Ref ref;

  void titleChanged(String value) {
    state = state.copyWith(title: value, textChanged: true);
    _validateTitle(value);
  }

  void _validateTitle(String value) {
    state = state.copyWith(
      titleError: value.trim().isEmpty ? 'Enter title'.hardcoded : null,
    );
  }

  void descriptionChanged(String value) {
    state = state.copyWith(description: value, textChanged: true);
  }

  void repoChanged(String value) {
    state = state.copyWith(repoUrl: value, textChanged: true);
  }

  void liveChanged(String value) {
    state = state.copyWith(liveUrl: value, textChanged: true);
  }

  void tagsChanged(String value) {
    state = state.copyWith(tags: value, textChanged: true);
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);
    final tags = state.tags
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final data = Project(
      id: id,
      title: state.title.trim(),
      description: state.description.trim().isEmpty ? null : state.description.trim(),
      repoUrl: state.repoUrl.trim().isEmpty ? null : state.repoUrl.trim(),
      liveUrl: state.liveUrl.trim().isEmpty ? null : state.liveUrl.trim(),
      tags: tags,
    );
    final controller = ref.read(projectsControllerProvider.notifier);
    final success =
        id == null ? await controller.createProject(data) : await controller.updateProject(
          id,
          data,
        );

    state = state.copyWith(isSubmitting: false);
    return success;
  }
}

final projectFormProvider = StateNotifierProvider.autoDispose
    .family<ProjectFormNotifier, ProjectFormState, Project?>(
      (ref, item) => ProjectFormNotifier(ref, item),
    );
