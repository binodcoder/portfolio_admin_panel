import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class AboutFormNotifier extends StateNotifier<AboutFormState> {
  AboutFormNotifier(this.ref, About? initialAbout)
    : super(AboutFormState(aboutText: initialAbout?.value ?? '')) {
    _validateAboutText(state.aboutText);
  }

  final Ref ref;

  void aboutTextChanged(String value) {
    state = state.copyWith(aboutText: value, textChanged: true);
    _validateAboutText(value);
  }

  void _validateAboutText(String value) {
    state = state.copyWith(
      aboutError: value.trim().isEmpty ? 'Enter About'.hardcoded : null,
    );
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;
    state = state.copyWith(isSubmitting: true);
    final data = About(id: id, value: state.aboutText.trim());
    final aboutController = ref.read(aboutControllerProvider.notifier);
    final result = id == null
        ? aboutController.createAbout(data)
        : aboutController.updateAbout(id, data);
    state = state.copyWith(isSubmitting: false);
    return result;
  }
}

final aboutFormProvider = StateNotifierProvider.autoDispose
    .family<AboutFormNotifier, AboutFormState, About?>((ref, item) {
      return AboutFormNotifier(ref, item);
    });
