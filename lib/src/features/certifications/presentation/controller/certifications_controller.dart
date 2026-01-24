import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/certifications/data/certifications_repository.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';

class CertificationsController extends StateNotifier<AsyncValue> {
  CertificationsController({required this.certificationsRepository})
    : super(AsyncValue.data(null));

  final CertificationsRepository certificationsRepository;

  Future<bool> createCertification({
    required String name,
    required String issuer,
    required String issueDate,
    required String expiryDate,
    required String credentialId,
    required String credentialUrl,
  }) async {
    final issueDateValue = DateTime.parse(issueDate);
    final expiryDateValue = DateTime.parse(expiryDate);
    final data = Certification(
      name: name,
      issuer: issuer,
      issueDate: issueDateValue,
      expiryDate: expiryDateValue,
      credentialId: credentialId,
      credentialUrl: credentialUrl,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => certificationsRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateCertification({
    required Certification data,
    required String name,
    required String issuer,
    required String issueDate,
    required String expiryDate,
    required String credentialId,
    required String credentialUrl,
  }) async {
    final issueDateValue = DateTime.parse(issueDate);
    final expiryDateValue = DateTime.parse(expiryDate);
    final updatedData = data.copyWith(
      name: name,
      issuer: issuer,
      issueDate: issueDateValue,
      expiryDate: expiryDateValue,
      credentialId: credentialId,
      credentialUrl: credentialUrl,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => certificationsRepository.update(updatedData));
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
