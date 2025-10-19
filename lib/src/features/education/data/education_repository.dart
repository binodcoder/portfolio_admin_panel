import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';

part 'education_repository.g.dart';

class EducationRepository {
  EducationRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('education');

  Stream<List<Education>> watch() => _collection.snapshots().map((s) => s.docs
      .map((d) => Education.fromMap({...d.data(), 'id': d.id}))
      .toList());

  Future<void> create(Education data) => _collection.add(data.toMap());
  Future<void> update(String id, Education data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

@Riverpod(keepAlive: true)
EducationRepository educationRepository(Ref ref) {
  return EducationRepository(FirebaseFirestore.instance);
}
