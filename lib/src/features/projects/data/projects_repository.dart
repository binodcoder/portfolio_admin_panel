import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:binodfolioadmin/src/features/projects/domain/project.dart';

class ProjectsRepository {
  ProjectsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('projects');

  Stream<List<Project>> watch() => _collection.snapshots().map(
    (s) => s.docs.map((d) => Project.fromMap({...d.data(), 'id': d.id})).toList(),
  );

  Future<void> create(Project data) => _collection.add(data.toMap());
  Future<void> update(Project data) => _collection.doc(data.id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

final projectRepositoryProvider = Provider.autoDispose<ProjectsRepository>((ref) {
  return ProjectsRepository(FirebaseFirestore.instance);
});

final projectListProvider = StreamProvider.autoDispose<List<Project>>((ref) {
  final projectRepository = ref.watch(projectRepositoryProvider);
  return projectRepository.watch();
});
