import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_action_controller.g.dart';

@riverpod
class IntroActionController extends _$IntroActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createIntro(Intro intro) async {
    final introRepository = ref.read(introRepositoryProvider);
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => introRepository.createIntro(intro));
  }

  Future<void> updateIntro(String id, Intro data) async {
    final introRepository = ref.read(introRepositoryProvider);
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => introRepository.updateIntro(id, data));
  }

  Future<void> deleteIntro(String id) async {
    final introRepository = ref.read(introRepositoryProvider);
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => introRepository.deleteIntro(id));
  }
}
