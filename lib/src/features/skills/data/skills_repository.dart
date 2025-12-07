import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';

class SkillsRepository {
  SkillsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('skills');

  Stream<List<Skill>> watch() => _collection.snapshots().map(
    (s) => s.docs.map((d) => Skill.fromMap({...d.data(), 'id': d.id})).toList(),
  );

  Future<void> create(Skill data) => _collection.add(data.toMap());
  Future<void> update(String id, Skill data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

final skillsRepositoryProvider = Provider<SkillsRepository>((ref) {
  return SkillsRepository(FirebaseFirestore.instance);
});

final skillListProvider = StreamProvider.autoDispose<List<Skill>>((ref) {
  final skillsRepository = ref.watch(skillsRepositoryProvider);
  return skillsRepository.watch();
});
