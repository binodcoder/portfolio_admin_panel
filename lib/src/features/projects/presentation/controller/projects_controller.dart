import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/projects/data/projects_repository.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';

part 'projects_controller.g.dart';

@riverpod
class ProjectsController extends _$ProjectsController {
  @override
  Stream<List<Project>> build() {
    final repo = ref.watch(projectsRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class ProjectsActionController extends _$ProjectsActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createProject(Project data) async {
    final repo = ref.read(projectsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateProject(String id, Project data) async {
    final repo = ref.read(projectsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteProject(String id) async {
    final repo = ref.read(projectsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
