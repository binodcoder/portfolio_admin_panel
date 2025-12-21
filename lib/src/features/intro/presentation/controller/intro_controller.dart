import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:riverpod/legacy.dart';

class IntroController extends StateNotifier<AsyncValue> {
  IntroController({required this.introRepository}) : super(AsyncValue.data(null));

  final IntroRepository introRepository;

  Future<bool> createIntro(Intro intro) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => introRepository.create(intro));
    return state.hasError == false;
  }

  Future<bool> updateIntro(String id, Intro data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => introRepository.updateIntro(id, data));
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

final introCanSaveProvider = StateProvider.autoDispose<bool>((ref) => false);
