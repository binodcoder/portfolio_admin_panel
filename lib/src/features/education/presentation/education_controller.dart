import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/education/data/education_repository.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';

part 'education_controller.g.dart';

@riverpod
class EducationController extends _$EducationController {
  @override
  Stream<List<Education>> build() {
    final repo = ref.watch(educationRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class EducationActionController extends _$EducationActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createEducation(Education data) async {
    final repo = ref.read(educationRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateEducation(String id, Education data) async {
    final repo = ref.read(educationRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteEducation(String id) async {
    final repo = ref.read(educationRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
