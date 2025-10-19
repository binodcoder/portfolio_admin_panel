import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/skills/data/skills_repository.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';

part 'skills_controller.g.dart';

@riverpod
class SkillsController extends _$SkillsController {
  @override
  Stream<List<Skill>> build() {
    final repo = ref.watch(skillsRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class SkillsActionController extends _$SkillsActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createSkill(Skill data) async {
    final repo = ref.read(skillsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateSkill(String id, Skill data) async {
    final repo = ref.read(skillsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteSkill(String id) async {
    final repo = ref.read(skillsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
