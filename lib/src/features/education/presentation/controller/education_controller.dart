import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/education/data/education_repository.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';

class EducationController extends StateNotifier<AsyncValue> {
  EducationController({required this.educationRepository}) : super(AsyncValue.data(null));

  final EducationRepository educationRepository;

  Future<bool> createEducation({
    required String institution,
    required String degree,
    required String field,
    required String start,
    required String end,
    required String location,
    required String gpa,
    required String description,
  }) async {
    final startValue = DateTime.parse(start);
    final endValue = DateTime.parse(end);
    final data = Education(
      institution: institution,
      degree: degree,
      field: field,
      start: startValue,
      end: endValue,
      location: location,
      gpa: gpa,
      description: description,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => educationRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateEducation({
    required Education data,
    required String institution,
    required String degree,
    required String field,
    required String start,
    required String end,
    required String location,
    required String gpa,
    required String description,
  }) async {
    final startValue = DateTime.parse(start);
    final endValue = DateTime.parse(end);
    final updatedData = data.copyWith(
      institution: institution,
      degree: degree,
      field: field,
      start: startValue,
      end: endValue,
      location: location,
      gpa: gpa,
      description: description,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => educationRepository.update(updatedData));
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
