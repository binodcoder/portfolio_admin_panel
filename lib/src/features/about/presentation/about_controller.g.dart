// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AboutController)
const aboutControllerProvider = AboutControllerProvider._();

final class AboutControllerProvider
    extends $StreamNotifierProvider<AboutController, List<About>> {
  const AboutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutControllerHash();

  @$internal
  @override
  AboutController create() => AboutController();
}

String _$aboutControllerHash() => r'b7a59790b86f06e466385a5746becc23bbc6c91b';

abstract class _$AboutController extends $StreamNotifier<List<About>> {
  Stream<List<About>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<About>>, List<About>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<About>>, List<About>>,
              AsyncValue<List<About>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AboutActionController)
const aboutActionControllerProvider = AboutActionControllerProvider._();

final class AboutActionControllerProvider
    extends $AsyncNotifierProvider<AboutActionController, void> {
  const AboutActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutActionControllerHash();

  @$internal
  @override
  AboutActionController create() => AboutActionController();
}

String _$aboutActionControllerHash() =>
    r'ac7be6466edc2b4fd2dd6450c99326361280d649';

abstract class _$AboutActionController extends $AsyncNotifier<void> {
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
