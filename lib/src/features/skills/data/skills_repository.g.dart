// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skills_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(skillsRepository)
const skillsRepositoryProvider = SkillsRepositoryProvider._();

final class SkillsRepositoryProvider
    extends
        $FunctionalProvider<
          SkillsRepository,
          SkillsRepository,
          SkillsRepository
        >
    with $Provider<SkillsRepository> {
  const SkillsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'skillsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$skillsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SkillsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SkillsRepository create(Ref ref) {
    return skillsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SkillsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SkillsRepository>(value),
    );
  }
}

String _$skillsRepositoryHash() => r'6f6af5adca1c48bf282061527e05edfb0fbeeee0';
