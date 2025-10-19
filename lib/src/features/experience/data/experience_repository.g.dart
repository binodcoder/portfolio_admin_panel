// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(experienceRepository)
const experienceRepositoryProvider = ExperienceRepositoryProvider._();

final class ExperienceRepositoryProvider
    extends
        $FunctionalProvider<
          ExperienceRepository,
          ExperienceRepository,
          ExperienceRepository
        >
    with $Provider<ExperienceRepository> {
  const ExperienceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'experienceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$experienceRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExperienceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExperienceRepository create(Ref ref) {
    return experienceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExperienceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExperienceRepository>(value),
    );
  }
}

String _$experienceRepositoryHash() =>
    r'56688c8bb10e2e4193ef74a62d34099bbfa96dbd';
