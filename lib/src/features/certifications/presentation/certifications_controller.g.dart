// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CertificationsController)
const certificationsControllerProvider = CertificationsControllerProvider._();

final class CertificationsControllerProvider
    extends
        $StreamNotifierProvider<CertificationsController, List<Certification>> {
  const CertificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'certificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$certificationsControllerHash();

  @$internal
  @override
  CertificationsController create() => CertificationsController();
}

String _$certificationsControllerHash() =>
    r'0e5e111613ab25a7cb974fc02ec4dbd346e13782';

abstract class _$CertificationsController
    extends $StreamNotifier<List<Certification>> {
  Stream<List<Certification>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Certification>>, List<Certification>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Certification>>, List<Certification>>,
              AsyncValue<List<Certification>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CertificationsActionController)
const certificationsActionControllerProvider =
    CertificationsActionControllerProvider._();

final class CertificationsActionControllerProvider
    extends $AsyncNotifierProvider<CertificationsActionController, void> {
  const CertificationsActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'certificationsActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$certificationsActionControllerHash();

  @$internal
  @override
  CertificationsActionController create() => CertificationsActionController();
}

String _$certificationsActionControllerHash() =>
    r'0b92e0b2ce69318777b1d589605399b4e3c18bb8';

abstract class _$CertificationsActionController extends $AsyncNotifier<void> {
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
