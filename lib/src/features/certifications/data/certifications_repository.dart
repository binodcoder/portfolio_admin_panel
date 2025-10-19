import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';

part 'certifications_repository.g.dart';

class CertificationsRepository {
  CertificationsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('certifications');

  Stream<List<Certification>> watch() => _collection.snapshots().map((s) => s.docs
      .map((d) => Certification.fromMap({...d.data(), 'id': d.id}))
      .toList());

  Future<void> create(Certification data) => _collection.add(data.toMap());
  Future<void> update(String id, Certification data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

@Riverpod(keepAlive: true)
CertificationsRepository certificationsRepository(Ref ref) {
  return CertificationsRepository(FirebaseFirestore.instance);
}
