import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:binodfolioadmin/src/features/contact/domain/contact_info.dart';

class ContactRepository {
  ContactRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('contact');

  Stream<List<ContactInfo>> watch() => _collection.snapshots().map(
    (s) => s.docs.map((d) => ContactInfo.fromMap({...d.data(), 'id': d.id})).toList(),
  );

  Future<void> create(ContactInfo data) => _collection.add(data.toMap());
  Future<void> update(ContactInfo data) => _collection.doc(data.id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository(FirebaseFirestore.instance);
});

final contactInfoListProvider = StreamProvider.autoDispose<List<ContactInfo>>((ref) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return contactRepository.watch();
});
