// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_action_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
