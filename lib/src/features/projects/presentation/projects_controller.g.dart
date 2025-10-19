// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProjectsController)
const projectsControllerProvider = ProjectsControllerProvider._();

final class ProjectsControllerProvider
    extends $StreamNotifierProvider<ProjectsController, List<Project>> {
  const ProjectsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsControllerHash();

  @$internal
  @override
  ProjectsController create() => ProjectsController();
}

String _$projectsControllerHash() =>
    r'3fc7ca41a54c6e2ade5777a08a284d50116f2737';

abstract class _$ProjectsController extends $StreamNotifier<List<Project>> {
  Stream<List<Project>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Project>>, List<Project>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Project>>, List<Project>>,
              AsyncValue<List<Project>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProjectsActionController)
const projectsActionControllerProvider = ProjectsActionControllerProvider._();

final class ProjectsActionControllerProvider
    extends $AsyncNotifierProvider<ProjectsActionController, void> {
  const ProjectsActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsActionControllerHash();

  @$internal
  @override
  ProjectsActionController create() => ProjectsActionController();
}

String _$projectsActionControllerHash() =>
    r'2c6563380d29d9699eee97a2017685803471116c';

abstract class _$ProjectsActionController extends $AsyncNotifier<void> {
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
