// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExperienceController)
const experienceControllerProvider = ExperienceControllerProvider._();

final class ExperienceControllerProvider
    extends $StreamNotifierProvider<ExperienceController, List<Experience>> {
  const ExperienceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'experienceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$experienceControllerHash();

  @$internal
  @override
  ExperienceController create() => ExperienceController();
}

String _$experienceControllerHash() =>
    r'7ca7457f9a83f8fd57b6927fe4379b201e926568';

abstract class _$ExperienceController
    extends $StreamNotifier<List<Experience>> {
  Stream<List<Experience>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Experience>>, List<Experience>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Experience>>, List<Experience>>,
              AsyncValue<List<Experience>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ExperienceActionController)
const experienceActionControllerProvider =
    ExperienceActionControllerProvider._();

final class ExperienceActionControllerProvider
    extends $AsyncNotifierProvider<ExperienceActionController, void> {
  const ExperienceActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'experienceActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$experienceActionControllerHash();

  @$internal
  @override
  ExperienceActionController create() => ExperienceActionController();
}

String _$experienceActionControllerHash() =>
    r'dc6fcd2ba12a0ade411652c9f6655820639ca976';

abstract class _$ExperienceActionController extends $AsyncNotifier<void> {
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
