import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:binodfolioadmin/src/features/projects/data/projects_repository.dart';
import 'package:binodfolioadmin/src/features/projects/domain/project.dart';

class ProjectsController extends StateNotifier<AsyncValue> {
  ProjectsController({required this.projectsRepository}) : super(AsyncValue.data(null));
  final ProjectsRepository projectsRepository;

  Future<bool> createProject({
    required String title,
    required String description,
    required String repoUrl,
    required String liveUrl,
    required String tags,
  }) async {
    final tagList = tags
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final data = Project(
      title: title,
      description: description,
      repoUrl: repoUrl,
      liveUrl: liveUrl,
      tags: tagList,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => projectsRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateProject({
    required Project data,
    required String title,
    required String description,
    required String repoUrl,
    required String liveUrl,
    required String tags,
  }) async {
    final tagList = tags
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final updatedData = data.copyWith(
      title: title,
      description: description,
      repoUrl: repoUrl,
      liveUrl: liveUrl,
      tags: tagList,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => projectsRepository.update(updatedData));
    return state.hasError == false;
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
