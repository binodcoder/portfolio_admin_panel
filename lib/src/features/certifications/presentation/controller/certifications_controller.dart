import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/certifications/data/certifications_repository.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';

class CertificationsController extends StateNotifier<AsyncValue> {
  CertificationsController({required this.certificationsRepository})
    : super(AsyncValue.data(null));

  final CertificationsRepository certificationsRepository;

  Future<bool> createCertification(Certification data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => certificationsRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateCertification(String id, Certification data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => certificationsRepository.update(id, data));
    return state.hasError == false;
  }

  Future<void> deleteCertification(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => certificationsRepository.delete(id));
  }
}

final certificationControllerProvider =
    StateNotifierProvider<CertificationsController, AsyncValue>((ref) {
      final certificationsRepository = ref.watch(certificationRepositoryProvider);
      return CertificationsController(certificationsRepository: certificationsRepository);
    });
