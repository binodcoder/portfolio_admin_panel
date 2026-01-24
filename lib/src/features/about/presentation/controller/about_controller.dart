import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/about/data/about_repository.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';

class AboutController extends StateNotifier<AsyncValue> {
  AboutController({required this.aboutRepository}) : super(AsyncValue.data(null));

  final AboutRepository aboutRepository;

  Future<bool> createAbout({required String value}) async {
    final data = About(value: value);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => aboutRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateAbout({required About data, required String value}) async {
    final updatedData = data.copyWith(value: value);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => aboutRepository.update(updatedData));
    return state.hasError == false;
  }

  Future<void> deleteAbout(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => aboutRepository.delete(id));
  }
}

final aboutControllerProvider = StateNotifierProvider<AboutController, AsyncValue>((ref) {
  final aboutRepository = ref.watch(aboutRepositoryProvider);
  return AboutController(aboutRepository: aboutRepository);
});
