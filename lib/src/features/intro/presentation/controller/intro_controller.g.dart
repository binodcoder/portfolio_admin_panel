// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IntroController)
const introControllerProvider = IntroControllerProvider._();

final class IntroControllerProvider
    extends $StreamNotifierProvider<IntroController, List<Intro>> {
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
  IntroController create() => IntroController();
}

String _$introControllerHash() => r'0360498fba45de42bba9313b6a3e70ca873aadcd';

abstract class _$IntroController extends $StreamNotifier<List<Intro>> {
  Stream<List<Intro>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Intro>>, List<Intro>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Intro>>, List<Intro>>,
              AsyncValue<List<Intro>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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
    r'e4d865ea0e77d315aac2d3622493daf6a5ac97ea';

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

@ProviderFor(introById)
const introByIdProvider = IntroByIdFamily._();

final class IntroByIdProvider
    extends $FunctionalProvider<AsyncValue<Intro?>, Intro?, Stream<Intro?>>
    with $FutureModifier<Intro?>, $StreamProvider<Intro?> {
  const IntroByIdProvider._({
    required IntroByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'introByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$introByIdHash();

  @override
  String toString() {
    return r'introByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Intro?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Intro?> create(Ref ref) {
    final argument = this.argument as String;
    return introById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IntroByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$introByIdHash() => r'783833708db340d31c6ffec98d871aaf4486b638';

final class IntroByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Intro?>, String> {
  const IntroByIdFamily._()
    : super(
        retry: null,
        name: r'introByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IntroByIdProvider call(String id) =>
      IntroByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'introByIdProvider';
}
