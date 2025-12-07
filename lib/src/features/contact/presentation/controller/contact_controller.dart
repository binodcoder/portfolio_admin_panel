import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/contact/data/contact_repository.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';

class ContactController extends StateNotifier<AsyncValue> {
  ContactController({required this.contactRepository}) : super(AsyncValue.data(null));

  final ContactRepository contactRepository;

  Future<void> createContact(ContactInfo data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.create(data));
  }

  Future<void> updateContact(String id, ContactInfo data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.update(id, data));
  }

  Future<void> deleteContact(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.delete(id));
  }
}

final contactControllerProvider =
    StateNotifierProvider.autoDispose<ContactController, AsyncValue>((ref) {
      final contactRepository = ref.watch(contactRepositoryProvider);
      return ContactController(contactRepository: contactRepository);
    });
