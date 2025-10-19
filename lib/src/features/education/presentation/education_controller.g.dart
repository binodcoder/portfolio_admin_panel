// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EducationController)
const educationControllerProvider = EducationControllerProvider._();

final class EducationControllerProvider
    extends $StreamNotifierProvider<EducationController, List<Education>> {
  const EducationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationControllerHash();

  @$internal
  @override
  EducationController create() => EducationController();
}

String _$educationControllerHash() =>
    r'64cf0cac179e7ddb36ed0c5f3120ff2f16e73e77';

abstract class _$EducationController extends $StreamNotifier<List<Education>> {
  Stream<List<Education>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Education>>, List<Education>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Education>>, List<Education>>,
              AsyncValue<List<Education>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(EducationActionController)
const educationActionControllerProvider = EducationActionControllerProvider._();

final class EducationActionControllerProvider
    extends $AsyncNotifierProvider<EducationActionController, void> {
  const EducationActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationActionControllerHash();

  @$internal
  @override
  EducationActionController create() => EducationActionController();
}

String _$educationActionControllerHash() =>
    r'0b1728a50e7a8e9167aff70e762b7bd33f8322db';

abstract class _$EducationActionController extends $AsyncNotifier<void> {
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
