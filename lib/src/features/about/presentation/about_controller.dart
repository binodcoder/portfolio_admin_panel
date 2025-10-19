import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/about/data/about_repository.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';

part 'about_controller.g.dart';

@riverpod
class AboutController extends _$AboutController {
  @override
  Stream<List<About>> build() {
    final repo = ref.watch(aboutRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class AboutActionController extends _$AboutActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createAbout(About data) async {
    final repo = ref.read(aboutRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateAbout(String id, About data) async {
    final repo = ref.read(aboutRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteAbout(String id) async {
    final repo = ref.read(aboutRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
