import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:binodfolioadmin/src/features/social/domain/social_link.dart';

class SocialRepository {
  SocialRepository(this._firestore);
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('socials');

  Stream<List<SocialLink>> watch() => _collection.snapshots().map(
    (s) => s.docs.map((d) => SocialLink.fromMap({...d.data(), 'id': d.id})).toList(),
  );
  Future<void> create(SocialLink data) => _collection.add(data.toMap());

  Future<void> update(SocialLink data) async {
    await Future.delayed(Duration(seconds: 4));
    throw Exception('failed to update');
  }
  // _collection.doc(id).update(data.toMap());

  Future<void> delete(String id) => _collection.doc(id).delete();
}

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(FirebaseFirestore.instance);
});

final socialLinkListProvider = StreamProvider.autoDispose<List<SocialLink>>((ref) {
  final socialRepository = ref.watch(socialRepositoryProvider);
  return socialRepository.watch();
});
