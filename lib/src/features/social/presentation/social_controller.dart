import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/social/data/social_repository.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';

part 'social_controller.g.dart';

@riverpod
class SocialController extends _$SocialController {
  @override
  Stream<List<SocialLink>> build() {
    final repo = ref.watch(socialRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class SocialActionController extends _$SocialActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createSocial(SocialLink data) async {
    final repo = ref.read(socialRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateSocial(String id, SocialLink data) async {
    final repo = ref.read(socialRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteSocial(String id) async {
    final repo = ref.read(socialRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
