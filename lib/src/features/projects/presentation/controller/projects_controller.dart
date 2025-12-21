import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/projects/data/projects_repository.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';

class ProjectsController extends StateNotifier<AsyncValue> {
  ProjectsController({required this.projectsRepository}) : super(AsyncValue.data(null));
  final ProjectsRepository projectsRepository;

  Future<void> createProject(Project data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => projectsRepository.create(data));
  }

  Future<void> updateProject(String id, Project data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => projectsRepository.update(id, data));
  }

  Future<void> deleteProject(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => projectsRepository.delete(id));
  }
}

final projectsControllerProvider = StateNotifierProvider<ProjectsController, AsyncValue>((
  ref,
) {
  final projectsRepository = ref.watch(projectRepositoryProvider);
  return ProjectsController(projectsRepository: projectsRepository);
});
