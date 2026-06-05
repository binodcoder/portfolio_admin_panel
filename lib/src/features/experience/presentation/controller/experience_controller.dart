import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:binodfolioadmin/src/features/experience/data/experience_repository.dart';
import 'package:binodfolioadmin/src/features/experience/domain/experience.dart';

class ExperienceController extends StateNotifier<AsyncValue> {
  ExperienceController({required this.experienceRepository})
    : super(AsyncValue.data(null));

  final ExperienceRepository experienceRepository;

  Future<bool> createExperience({
    required String company,
    required String title,
    required String location,
    required String start,
    required String end,
    required bool current,
    required String description,
    required String technologies,
  }) async {
    final techs = technologies
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final startValue = DateTime.parse(start);
    final endValue = DateTime.parse(end);

    final data = Experience(
      company: company,
      title: title,
      location: location,
      start: startValue,
      end: endValue,
      current: current,
      description: description,
      technologies: techs,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => experienceRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateExperience({
    required Experience data,
    required String company,
    required String title,
    required String location,
    required String start,
    required String end,
    required bool current,
    required String description,
    required String technologies,
  }) async {
    final techs = technologies
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final startValue = DateTime.parse(start);
    final endValue = DateTime.parse(end);
    final updatedData = data.copyWith(
      company: company,
      title: title,
      location: location,
      start: startValue,
      end: endValue,
      current: current,
      description: description,
      technologies: techs,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => experienceRepository.update(updatedData));
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
