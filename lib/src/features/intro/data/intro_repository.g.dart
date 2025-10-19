// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(introRepository)
const introRepositoryProvider = IntroRepositoryProvider._();

final class IntroRepositoryProvider
    extends
        $FunctionalProvider<IntroRepository, IntroRepository, IntroRepository>
    with $Provider<IntroRepository> {
  const IntroRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'introRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$introRepositoryHash();

  @$internal
  @override
  $ProviderElement<IntroRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IntroRepository create(Ref ref) {
    return introRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IntroRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IntroRepository>(value),
    );
  }
}

String _$introRepositoryHash() => r'1133b8b3272191fef51072c49e1de97b59122590';
