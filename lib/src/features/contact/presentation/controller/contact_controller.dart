import 'package:riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/contact/data/contact_repository.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';

class ContactController extends StateNotifier<AsyncValue> {
  ContactController({required this.contactRepository}) : super(AsyncValue.data(null));

  final ContactRepository contactRepository;

  Future<bool> createContact(ContactInfo data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateContact(String id, ContactInfo data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.update(id, data));
    return state.hasError == false;
  }

  Future<void> deleteContact(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.delete(id));
  }
}

final contactControllerProvider = StateNotifierProvider<ContactController, AsyncValue>((
  ref,
) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return ContactController(contactRepository: contactRepository);
});
