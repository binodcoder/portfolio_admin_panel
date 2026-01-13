import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/education/data/education_repository.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';

class EducationController extends StateNotifier<AsyncValue> {
  EducationController({required this.educationRepository}) : super(AsyncValue.data(null));

  final EducationRepository educationRepository;

  Future<bool> createEducation(Education data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => educationRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateEducation(String id, Education data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => educationRepository.update(id, data));
    return state.hasError == false;
  }

  Future<void> deleteEducation(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => educationRepository.delete(id));
  }
}

final educationControllerProvider =
    StateNotifierProvider<EducationController, AsyncValue>((ref) {
      final educationRepository = ref.watch(educationRepositoryProvider);
      return EducationController(educationRepository: educationRepository);
    });
