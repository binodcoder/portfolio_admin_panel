// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactController)
const contactControllerProvider = ContactControllerProvider._();

final class ContactControllerProvider
    extends $StreamNotifierProvider<ContactController, List<ContactInfo>> {
  const ContactControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactControllerHash();

  @$internal
  @override
  ContactController create() => ContactController();
}

String _$contactControllerHash() => r'681098e573db3c046ed6641c2c5da398bb205b20';

abstract class _$ContactController extends $StreamNotifier<List<ContactInfo>> {
  Stream<List<ContactInfo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<ContactInfo>>, List<ContactInfo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ContactInfo>>, List<ContactInfo>>,
              AsyncValue<List<ContactInfo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ContactActionController)
const contactActionControllerProvider = ContactActionControllerProvider._();

final class ContactActionControllerProvider
    extends $AsyncNotifierProvider<ContactActionController, void> {
  const ContactActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactActionControllerHash();

  @$internal
  @override
  ContactActionController create() => ContactActionController();
}

String _$contactActionControllerHash() =>
    r'b1e245a48a0d3e5ebaa4423ec25629a67f5475a5';

abstract class _$ContactActionController extends $AsyncNotifier<void> {
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
