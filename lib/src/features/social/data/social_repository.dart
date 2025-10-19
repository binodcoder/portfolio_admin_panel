import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';

part 'social_repository.g.dart';

class SocialRepository {
  SocialRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('socials');

  Stream<List<SocialLink>> watch() => _collection.snapshots().map((s) => s.docs
      .map((d) => SocialLink.fromMap({...d.data(), 'id': d.id}))
      .toList());
  Future<void> create(SocialLink data) => _collection.add(data.toMap());
  Future<void> update(String id, SocialLink data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

@Riverpod(keepAlive: true)
SocialRepository socialRepository(Ref ref) {
  return SocialRepository(FirebaseFirestore.instance);
}
