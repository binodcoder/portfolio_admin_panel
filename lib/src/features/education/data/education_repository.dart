import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';

class EducationRepository {
  EducationRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('education');

  Stream<List<Education>> watch() => _collection.snapshots().map(
    (s) => s.docs.map((d) => Education.fromMap({...d.data(), 'id': d.id})).toList(),
  );

  Future<void> create(Education data) => _collection.add(data.toMap());
  Future<void> update(Education data) => _collection.doc(data.id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

final educationRepositoryProvider = Provider.autoDispose<EducationRepository>((ref) {
  return EducationRepository(FirebaseFirestore.instance);
});

final educationListProvider = StreamProvider.autoDispose<List<Education>>((ref) {
  final educationRepository = ref.watch(educationRepositoryProvider);
  return educationRepository.watch();
});
