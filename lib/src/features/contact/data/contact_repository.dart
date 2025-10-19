import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';

part 'contact_repository.g.dart';

class ContactRepository {
  ContactRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('contact');

  Stream<List<ContactInfo>> watch() => _collection.snapshots().map((s) => s.docs
      .map((d) => ContactInfo.fromMap({...d.data(), 'id': d.id}))
      .toList());

  Future<void> create(ContactInfo data) => _collection.add(data.toMap());
  Future<void> update(String id, ContactInfo data) => _collection.doc(id).update(data.toMap());
  Future<void> delete(String id) => _collection.doc(id).delete();
}

@Riverpod(keepAlive: true)
ContactRepository contactRepository(Ref ref) {
  return ContactRepository(FirebaseFirestore.instance);
}
