import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:binodfolioadmin/src/features/contact/data/contact_repository.dart';
import 'package:binodfolioadmin/src/features/contact/domain/contact_info.dart';

class ContactController extends StateNotifier<AsyncValue> {
  ContactController({required this.contactRepository}) : super(AsyncValue.data(null));

  final ContactRepository contactRepository;

  Future<bool> createContact({
    required String email,
    required String phone,
    required String location,
    required String website,
    required bool openToWork,
    required String message,
  }) async {
    final data = ContactInfo(
      email: email,
      phone: phone,
      location: location,
      website: website,
      openToWork: openToWork,
      message: message,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.create(data));
    return state.hasError == false;
  }

  Future<bool> updateContact({
    required ContactInfo data,
    required String email,
    required String phone,
    required String location,
    required String website,
    required bool openToWork,
    required String message,
  }) async {
    final updatedData = data.copyWith(
      phone: phone,
      location: location,
      website: website,
      openToWork: openToWork,
      message: message,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => contactRepository.update(updatedData));
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
