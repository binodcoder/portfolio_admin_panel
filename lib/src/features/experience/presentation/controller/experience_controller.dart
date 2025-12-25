import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/experience/data/experience_repository.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';

class ExperienceController extends StateNotifier<AsyncValue> {
  ExperienceController({required this.experienceRepository})
    : super(AsyncValue.data(null));

  final ExperienceRepository experienceRepository;

  Future<bool> createExperience(Experience data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => experienceRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateExperience(String id, Experience data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => experienceRepository.update(id, data));
    return state.hasError == false;
  }

  Future<void> deleteExperience(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => experienceRepository.delete(id));
  }
}

final experienceControllerProvider =
    StateNotifierProvider<ExperienceController, AsyncValue>((ref) {
      final experienceRepository = ref.watch(experienceRepositoryProvider);
      return ExperienceController(experienceRepository: experienceRepository);
    });
