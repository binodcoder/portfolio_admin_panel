import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:binodfolioadmin/src/features/about/domain/about.dart';

class AboutRepository {
  AboutRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('about');

  Future<void> create(About data) => _collection.add(data.toMap());

  Stream<List<About?>> watch() => _collection.snapshots().map(
    (snapshot) =>
        snapshot.docs.map((d) => About.fromMap({...d.data(), 'id': d.id})).toList(),
  );

  Stream<About?> watchAbout(String id) {
    return _collection.doc(id).snapshots().map((doc) => About.fromMap(doc.data()!));
  }

  Future<void> update(About data) async {
    return _collection.doc(data.id).update(data.toMap());
  }

  Future<void> delete(String id) async {
    return _collection.doc(id).delete();
  }
}

final aboutRepositoryProvider = Provider<AboutRepository>((ref) {
  return AboutRepository(FirebaseFirestore.instance);
});

final aboutListProvider = StreamProvider.autoDispose<List<About?>>((ref) {
  final aboutRepository = ref.watch(aboutRepositoryProvider);
  return aboutRepository.watch();
});

final watchAboutProvider = StreamProvider.autoDispose.family<About?, String>((ref, id) {
  final aboutRepository = ref.watch(aboutRepositoryProvider);
  return aboutRepository.watchAbout(id);
});
