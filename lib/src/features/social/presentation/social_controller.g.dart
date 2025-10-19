// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocialController)
const socialControllerProvider = SocialControllerProvider._();

final class SocialControllerProvider
    extends $StreamNotifierProvider<SocialController, List<SocialLink>> {
  const SocialControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialControllerHash();

  @$internal
  @override
  SocialController create() => SocialController();
}

String _$socialControllerHash() => r'9ddc0e099f8ddcd927e10bd91b838824c4f55903';

abstract class _$SocialController extends $StreamNotifier<List<SocialLink>> {
  Stream<List<SocialLink>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SocialLink>>, List<SocialLink>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SocialLink>>, List<SocialLink>>,
              AsyncValue<List<SocialLink>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SocialActionController)
const socialActionControllerProvider = SocialActionControllerProvider._();

final class SocialActionControllerProvider
    extends $AsyncNotifierProvider<SocialActionController, void> {
  const SocialActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialActionControllerHash();

  @$internal
  @override
  SocialActionController create() => SocialActionController();
}

String _$socialActionControllerHash() =>
    r'c356c829e5e9e0b11698afbc2258dccfe2b3b11e';

abstract class _$SocialActionController extends $AsyncNotifier<void> {
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
