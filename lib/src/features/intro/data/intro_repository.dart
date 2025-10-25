import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_repository.g.dart';

class IntroRepository {
  IntroRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Typed collection reference using Firestore converters
  CollectionReference<Intro> get _introCollection => _firestore
      .collection('intro')
      .withConverter<Intro>(
        fromFirestore: (snapshot, _) =>
            Intro.fromMap({...?snapshot.data(), 'id': snapshot.id}),
        toFirestore: (intro, _) => intro.toMap(),
      );

  Future<void> createIntro(Intro intro) {
    // Using add() to let Firestore generate the id
    return _introCollection.add(intro);
  }

  // Clearer naming: watch all intros
  Stream<List<Intro>> watchIntros() {
    return _introCollection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  Stream<Intro?> watchIntroById(String id) {
    return _introCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return doc.data();
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
