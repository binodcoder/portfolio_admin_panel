import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/social/data/social_repository.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';

class SocialController extends StateNotifier<AsyncValue> {
  SocialController({required this.socialRepository}) : super(AsyncValue.data(null));

  final SocialRepository socialRepository;

  Future<void> createSocial(SocialLink data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.create(data));
  }

  Future<void> updateSocial(String id, SocialLink data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.update(id, data));
  }

  Future<void> deleteSocial(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => socialRepository.delete(id));
  }
}

final socialControllerProvider =
    StateNotifierProvider.autoDispose<SocialController, AsyncValue>((ref) {
      final socialRepository = ref.watch(socialRepositoryProvider);
      return SocialController(socialRepository: socialRepository);
    });
