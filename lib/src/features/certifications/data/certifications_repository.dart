import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';

class CertificationsRepository {
  CertificationsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('certifications');

  Stream<List<Certification>> watch() => _collection.snapshots().map(
    (s) => s.docs.map((d) => Certification.fromMap({...d.data(), 'id': d.id})).toList(),
  );

  Future<void> create(Certification data) => _collection.add(data.toMap());
  Future<void> update(Certification data) =>
      _collection.doc(data.id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

final certificationRepositoryProvider = Provider<CertificationsRepository>((ref) {
  return CertificationsRepository(FirebaseFirestore.instance);
});

final certificationListProvider = StreamProvider.autoDispose<List<Certification>>((ref) {
  final certificationRepository = ref.watch(certificationRepositoryProvider);
  return certificationRepository.watch();
});
