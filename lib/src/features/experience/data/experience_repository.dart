import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';

part 'experience_repository.g.dart';

class ExperienceRepository {
  ExperienceRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('experience');

  Stream<List<Experience>> watch() => _collection.snapshots().map((s) => s.docs
      .map((d) => Experience.fromMap({...d.data(), 'id': d.id}))
      .toList());

  Future<void> create(Experience data) => _collection.add(data.toMap());
  Future<void> update(String id, Experience data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

@Riverpod(keepAlive: true)
ExperienceRepository experienceRepository(Ref ref) {
  return ExperienceRepository(FirebaseFirestore.instance);
}
