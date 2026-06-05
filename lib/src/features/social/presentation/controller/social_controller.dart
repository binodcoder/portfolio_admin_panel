import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:binodfolioadmin/src/features/social/data/social_repository.dart';
import 'package:binodfolioadmin/src/features/social/domain/social_link.dart';

class SocialController extends StateNotifier<AsyncValue> {
  SocialController({required this.socialRepository}) : super(AsyncValue.data(null));

  final SocialRepository socialRepository;

  Future<bool> createSocial({required String platform, required String url}) async {
    final data = SocialLink(platform: platform, url: url);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateSocial({
    required SocialLink data,
    required String platform,
    required String url,
  }) async {
    final updatedData = data.copyWith(platform: platform, url: url);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.update(updatedData));
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
