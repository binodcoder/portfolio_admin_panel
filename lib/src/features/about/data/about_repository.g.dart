// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aboutRepository)
const aboutRepositoryProvider = AboutRepositoryProvider._();

final class AboutRepositoryProvider
    extends
        $FunctionalProvider<AboutRepository, AboutRepository, AboutRepository>
    with $Provider<AboutRepository> {
  const AboutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutRepositoryHash();

  @$internal
  @override
  $ProviderElement<AboutRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AboutRepository create(Ref ref) {
    return aboutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutRepository>(value),
    );
  }
}

String _$aboutRepositoryHash() => r'90516548e8dd5f94afe966117f92355323754488';
