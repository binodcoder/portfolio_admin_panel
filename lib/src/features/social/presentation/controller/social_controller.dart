import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/social/data/social_repository.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';

class SocialController extends StateNotifier<AsyncValue> {
  SocialController({required this.socialRepository}) : super(AsyncValue.data(null));

  final SocialRepository socialRepository;

  Future<bool> createSocial(SocialLink data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateSocial(String id, SocialLink data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.update(id, data));
    return state.hasError == false;
  }

  Future<void> deleteSocial(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.delete(id));
  }
}

final socialControllerProvider = StateNotifierProvider<SocialController, AsyncValue>((
  ref,
) {
  final socialRepository = ref.watch(socialRepositoryProvider);
  return SocialController(socialRepository: socialRepository);
});
