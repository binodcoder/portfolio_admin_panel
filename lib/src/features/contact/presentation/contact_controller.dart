import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_admin_panel/src/features/contact/data/contact_repository.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';

part 'contact_controller.g.dart';

@riverpod
class ContactController extends _$ContactController {
  @override
  Stream<List<ContactInfo>> build() {
    final repo = ref.watch(contactRepositoryProvider);
    return repo.watch();
  }
}

@riverpod
class ContactActionController extends _$ContactActionController {
  @override
  FutureOr<void> build() {}

  Future<void> createContact(ContactInfo data) async {
    final repo = ref.read(contactRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.create(data));
  }

  Future<void> updateContact(String id, ContactInfo data) async {
    final repo = ref.read(contactRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, data));
  }

  Future<void> deleteContact(String id) async {
    final repo = ref.read(contactRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
  }
}
