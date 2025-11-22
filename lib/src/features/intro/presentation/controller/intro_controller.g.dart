// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(introController)
const introControllerProvider = IntroControllerProvider._();

final class IntroControllerProvider
    extends $FunctionalProvider<AsyncValue<Intro?>, Intro?, Stream<Intro?>>
    with $FutureModifier<Intro?>, $StreamProvider<Intro?> {
  const IntroControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'introControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$introControllerHash();

  @$internal
  @override
  $StreamProviderElement<Intro?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Intro?> create(Ref ref) {
    return introController(ref);
  }
}

String _$introControllerHash() => r'00e78b41eac6b354ddf35f284fd6457ec2b0250c';

@ProviderFor(IntroActionController)
const introActionControllerProvider = IntroActionControllerProvider._();

final class IntroActionControllerProvider
    extends $AsyncNotifierProvider<IntroActionController, void> {
  const IntroActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'introActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$introActionControllerHash();

  @$internal
  @override
  IntroActionController create() => IntroActionController();
}

String _$introActionControllerHash() =>
    r'a0dd93c25cd36c534b5ccd8005310e9650c8cd22';

abstract class _$IntroActionController extends $AsyncNotifier<void> {
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
