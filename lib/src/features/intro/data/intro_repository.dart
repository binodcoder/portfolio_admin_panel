import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';

class IntroRepository {
  IntroRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Single-document model: store the intro at intro/current
  DocumentReference<Intro> get _introDoc => _firestore
      .collection('intro')
      .doc('current')
      .withConverter<Intro>(
        fromFirestore: (snapshot, _) => snapshot.exists
            ? Intro.fromMap({...?snapshot.data(), 'id': snapshot.id})
            : const Intro(value: ''),
        toFirestore: (intro, _) => intro.toMap(),
      );

  // Stream the single intro document
  Stream<Intro?> watchIntro() {
    return _introDoc.snapshots().map((doc) => doc.exists ? doc.data() : null);
  }

  // Create or update the single intro document
  Future<void> setIntro(Intro data) {
    return _introDoc.set(data);
  }

  // Delete the single intro document
  Future<void> deleteIntro() {
    return _introDoc.delete();
  }
}

final introRepositoryProvider = Provider<IntroRepository>((ref) {
  return IntroRepository(FirebaseFirestore.instance);
});

final watchIntroProvider = StreamProvider.autoDispose<Intro?>((ref) {
  final introRepository = ref.watch(introRepositoryProvider);
  return introRepository.watchIntro();
});
