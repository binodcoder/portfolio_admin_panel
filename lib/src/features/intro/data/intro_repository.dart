import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';

class IntroRepository {
  IntroRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('intro');

  Future<void> create(Intro data) => _collection.add(data.toMap());

  Stream<List<Intro?>> watchIntro() {
    return _collection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((d) => Intro.fromMap({...d.data(), 'id': d.id})).toList(),
    );
  }

  Future<void> updateIntro(String id, Intro data) async {
    return _collection.doc(id).update(data.toMap());
  }

  Future<void> deleteIntro(String id) {
    return _collection.doc(id).delete();
  }
}

final introRepositoryProvider = Provider<IntroRepository>((ref) {
  return IntroRepository(FirebaseFirestore.instance);
});

final watchIntrosProvider = StreamProvider.autoDispose<List<Intro?>>((ref) {
  final introRepository = ref.watch(introRepositoryProvider);
  return introRepository.watchIntro();
});
