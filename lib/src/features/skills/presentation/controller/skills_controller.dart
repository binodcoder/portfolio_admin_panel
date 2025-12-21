import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/skills/data/skills_repository.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';

class SkillsController extends StateNotifier<AsyncValue> {
  SkillsController({required this.skillsRepository}) : super(AsyncValue.data(null));

  final SkillsRepository skillsRepository;

  Future<void> createSkill(Skill data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => skillsRepository.create(data));
  }

  Future<void> updateSkill(String id, Skill data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => skillsRepository.update(id, data));
  }

  Future<void> deleteSkill(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => skillsRepository.delete(id));
  }
}

final skillsControllerProvider = StateNotifierProvider<SkillsController, AsyncValue>((
  ref,
) {
  final skillsRepository = ref.watch(skillsRepositoryProvider);
  return SkillsController(skillsRepository: skillsRepository);
});
