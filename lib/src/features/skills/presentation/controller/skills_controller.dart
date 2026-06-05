import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:binodfolioadmin/src/features/skills/data/skills_repository.dart';
import 'package:binodfolioadmin/src/features/skills/domain/skill.dart';

class SkillsController extends StateNotifier<AsyncValue> {
  SkillsController({required this.skillsRepository}) : super(AsyncValue.data(null));

  final SkillsRepository skillsRepository;

  Future<bool> createSkill({
    required String name,
    required double level,
    required String category,
  }) async {
    final levelValue = level.round();
    final data = Skill(name: name, level: levelValue, category: category);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => skillsRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateSkill({
    required Skill data,
    required String name,
    required double level,
    required String category,
  }) async {
    final levelValue = level.round();
    final updatedData = data.copyWith(name: name, level: levelValue, category: category);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => skillsRepository.update(updatedData));
    return state.hasError == false;
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
