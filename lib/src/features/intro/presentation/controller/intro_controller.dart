import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_dialogs.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'intro_controller.g.dart';

@riverpod
class IntroController extends _$IntroController {
  @override
  Stream<List<Intro>> build() {
    final repo = ref.watch(introRepositoryProvider);
    return repo.watchIntros();
  }
}

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

  // Future<void> deleteIntro(String id) async {
  //   final introRepository = ref.read(introRepositoryProvider);
  //   state = AsyncValue.loading();
  //   state = await AsyncValue.guard(() => introRepository.deleteIntro(id));
  // }

  /// Navigate to edit page (existing or new)
  void goToEdit(BuildContext context, Intro? intro) {
    final idOrNew = intro?.id ?? 'new';
    context.goNamed(AppRoute.introEdit.name, pathParameters: {'id': idOrNew});
  }

  /// Delete the current intro after confirmation
  Future<void> deleteIntro(BuildContext context, Intro intro) async {
    final repo = ref.read(introRepositoryProvider);

    final confirmed = await IntroDialogs.confirmDelete(context);
    if (!confirmed) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repo.deleteIntro(intro.id!);
    });

    if (!context.mounted) return;

    state.whenOrNull(
      data: (_) => IntroDialogs.showSnack(context, 'Intro deleted successfully'),
      error: (err, _) => IntroDialogs.showSnack(context, 'Failed to delete: $err'),
    );
  }
}

@riverpod
Stream<Intro?> introById(Ref ref, String id) {
  final repo = ref.watch(introRepositoryProvider);
  return repo.watchIntroById(id);
}
