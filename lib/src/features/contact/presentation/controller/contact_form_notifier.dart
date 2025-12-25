import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_controller.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_form_state.dart';

class ContactFormNotifier extends StateNotifier<ContactFormState> {
  ContactFormNotifier(this.ref, ContactInfo? initial)
    : super(
        ContactFormState(
          email: initial?.email ?? '',
          phone: initial?.phone ?? '',
          location: initial?.location ?? '',
          website: initial?.website ?? '',
          message: initial?.message ?? '',
          openToWork: initial?.openToWork ?? true,
        ),
      );

  final Ref ref;

  void emailChanged(String value) {
    state = state.copyWith(email: value, textChanged: true);
  }

  void phoneChanged(String value) {
    state = state.copyWith(phone: value, textChanged: true);
  }

  void locationChanged(String value) {
    state = state.copyWith(location: value, textChanged: true);
  }

  void websiteChanged(String value) {
    state = state.copyWith(website: value, textChanged: true);
  }

  void messageChanged(String value) {
    state = state.copyWith(message: value, textChanged: true);
  }

  void openToWorkChanged(bool value) {
    state = state.copyWith(openToWork: value, textChanged: true);
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);

    final data = ContactInfo(
      id: id,
      email: state.email.trim().isEmpty ? null : state.email.trim(),
      phone: state.phone.trim().isEmpty ? null : state.phone.trim(),
      location: state.location.trim().isEmpty ? null : state.location.trim(),
      website: state.website.trim().isEmpty ? null : state.website.trim(),
      openToWork: state.openToWork,
      message: state.message.trim().isEmpty ? null : state.message.trim(),
    );

    final controller = ref.read(contactControllerProvider.notifier);
    final success =
        id == null ? await controller.createContact(data) : await controller.updateContact(
          id,
          data,
        );

    state = state.copyWith(isSubmitting: false);
    return success;
  }
}

final contactFormProvider = StateNotifierProvider.autoDispose
    .family<ContactFormNotifier, ContactFormState, ContactInfo?>(
      (ref, item) => ContactFormNotifier(ref, item),
    );
