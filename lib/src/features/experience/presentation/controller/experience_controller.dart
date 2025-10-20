import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/experience/data/experience_repository.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';

part 'experience_controller.g.dart';

@riverpod
class ExperienceController extends _$ExperienceController {
  @override
  Stream<List<Experience>> build() {
    final repo = ref.watch(experienceRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class ExperienceActionController extends _$ExperienceActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createExperience(Experience data) async {
    final repo = ref.read(experienceRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateExperience(String id, Experience data) async {
    final repo = ref.read(experienceRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteExperience(String id) async {
    final repo = ref.read(experienceRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
