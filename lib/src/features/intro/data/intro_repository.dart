import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_repository.g.dart';

class IntroRepository {
  IntroRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Collection reference (typed)
  CollectionReference<Map<String, dynamic>> get _introCollection =>
      _firestore.collection('intro');

  Future<void> createIntro(Intro intro) {
    // Using add() to let Firestore generate the id
    return _introCollection.add({'value': intro.value});
  }

  Stream<List<Intro>> getIntro() {
    return _introCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Intro.fromMap({...doc.data(), 'id': doc.id}))
          .toList(),
    );
  }

  Stream<Intro?> watchIntroById(String id) {
    return _introCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return Intro.fromMap({...data, 'id': doc.id});
    });
  }

  Future<void> updateIntro(String id, Intro data) {
    return _introCollection.doc(id).update(data.toMap());
  }

  Future<void> deleteIntro(String id) {
    return _introCollection.doc(id).delete();
  }
}

@Riverpod(keepAlive: true)
IntroRepository introRepository(Ref ref) {
  return IntroRepository(FirebaseFirestore.instance);
}
