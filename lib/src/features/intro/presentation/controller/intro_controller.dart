import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:binodfolioadmin/src/features/intro/data/intro_repository.dart';
import 'package:binodfolioadmin/src/features/intro/domain/intro.dart';

class IntroController extends StateNotifier<AsyncValue> {
  IntroController({required this.introRepository}) : super(AsyncValue.data(null));

  final IntroRepository introRepository;

  Future<bool> createIntro({required String introText}) async {
    final intro = Intro(value: introText);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => introRepository.create(intro));
    return state.hasError == false;
  }

  Future<bool> updateIntro({required Intro data, required String introText}) async {
    final updatedData = data.copyWith(value: introText);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => introRepository.updateIntro(updatedData));
    return state.hasError == false;
  }

  Future<void> deleteIntro(String id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => introRepository.deleteIntro(id));
  }
}

final introControllerProvider = StateNotifierProvider<IntroController, AsyncValue>((ref) {
  final introRepository = ref.watch(introRepositoryProvider);
  return IntroController(introRepository: introRepository);
});
