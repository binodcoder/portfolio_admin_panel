import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/certifications/data/certifications_repository.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';

part 'certifications_controller.g.dart';

@riverpod
class CertificationsController extends _$CertificationsController {
  @override
  Stream<List<Certification>> build() {
    final repo = ref.watch(certificationsRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class CertificationsActionController extends _$CertificationsActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createCertification(Certification data) async {
    final repo = ref.read(certificationsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateCertification(String id, Certification data) async {
    final repo = ref.read(certificationsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteCertification(String id) async {
    final repo = ref.read(certificationsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
