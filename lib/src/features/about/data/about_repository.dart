import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';

part 'about_repository.g.dart';

class AboutRepository {
  AboutRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('about');

  Future<void> create(About data) => _collection.add(data.toMap());

  Stream<List<About>> watch() {
    return _collection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((d) => About.fromMap({...d.data(), 'id': d.id})).toList(),
    );
  }

  Future<void> update(String id, About data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

@Riverpod(keepAlive: true)
AboutRepository aboutRepository(Ref ref) {
  return AboutRepository(FirebaseFirestore.instance);
}
