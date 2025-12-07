import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:riverpod/legacy.dart';

class IntroActionController extends StateNotifier<AsyncValue> {
  IntroActionController({required this.introRepository}) : super(AsyncValue.data(null));

  final IntroRepository introRepository;

  Future<bool> upsertIntro(Intro data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => introRepository.setIntro(data));
    return state.hasError == false;
  }

  Future<void> deleteIntro() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => introRepository.deleteIntro());
  }
}

final introActionControllerProvider =
    StateNotifierProvider.autoDispose<IntroActionController, AsyncValue>((ref) {
      final introRepository = ref.watch(introRepositoryProvider);
      return IntroActionController(introRepository: introRepository);
    });

 
