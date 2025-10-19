// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skills_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SkillsController)
const skillsControllerProvider = SkillsControllerProvider._();

final class SkillsControllerProvider
    extends $StreamNotifierProvider<SkillsController, List<Skill>> {
  const SkillsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'skillsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$skillsControllerHash();

  @$internal
  @override
  SkillsController create() => SkillsController();
}

String _$skillsControllerHash() => r'6fc8f545db465328d75a81c188450bfeb1b21b51';

abstract class _$SkillsController extends $StreamNotifier<List<Skill>> {
  Stream<List<Skill>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Skill>>, List<Skill>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Skill>>, List<Skill>>,
              AsyncValue<List<Skill>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SkillsActionController)
const skillsActionControllerProvider = SkillsActionControllerProvider._();

final class SkillsActionControllerProvider
    extends $AsyncNotifierProvider<SkillsActionController, void> {
  const SkillsActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'skillsActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$skillsActionControllerHash();

  @$internal
  @override
  SkillsActionController create() => SkillsActionController();
}

String _$skillsActionControllerHash() =>
    r'7bcfbe5f03e08d1a3b7578ed854e729df992912a';

abstract class _$SkillsActionController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
