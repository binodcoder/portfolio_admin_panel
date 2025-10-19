// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certifications_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(certificationsRepository)
const certificationsRepositoryProvider = CertificationsRepositoryProvider._();

final class CertificationsRepositoryProvider
    extends
        $FunctionalProvider<
          CertificationsRepository,
          CertificationsRepository,
          CertificationsRepository
        >
    with $Provider<CertificationsRepository> {
  const CertificationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'certificationsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$certificationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<CertificationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CertificationsRepository create(Ref ref) {
    return certificationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CertificationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CertificationsRepository>(value),
    );
  }
}

String _$certificationsRepositoryHash() =>
    r'49508014f6980a62347eab0a0f15e5b9343d80c5';
