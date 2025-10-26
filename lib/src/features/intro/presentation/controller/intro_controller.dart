import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/intro/data/intro_repository.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_dialogs.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'intro_controller.g.dart';

enum IntroActionKind { save, delete }

@riverpod
class IntroController extends _$IntroController {
  @override
  Stream<Intro?> build() {
    final repo = ref.watch(introRepositoryProvider);
    return repo.watchIntro();
  }
}

@riverpod
class IntroActionController extends _$IntroActionController {
  @override
  FutureOr<void> build() {}
  IntroActionKind? _lastAction;
  IntroActionKind? get lastAction => _lastAction;

  Future<void> upsertIntro(Intro data) async {
    final repo = ref.read(introRepositoryProvider);
    _lastAction = IntroActionKind.save;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.setIntro(data));
  }

  /// Navigate to edit page (single-doc: always "current")
  void goToEdit(BuildContext context, Intro? intro) {
    const id = 'current';
    context.goNamed(AppRoute.introEdit.name, pathParameters: {'id': id});
  }

  /// Delete the current intro after confirmation (single-doc)
  Future<void> deleteIntro(BuildContext context) async {
    final repo = ref.read(introRepositoryProvider);

    final confirmed = await IntroDialogs.confirmDelete(context);
    if (!confirmed) return;

    _lastAction = IntroActionKind.delete;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repo.deleteIntro();
    });
  }
}

// single-doc model eliminates the need for an id-based provider
