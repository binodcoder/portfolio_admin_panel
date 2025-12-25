import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class IntroFormNotifier extends StateNotifier<IntroFormState> {
  IntroFormNotifier(this.ref, Intro? initialIntro)
    : super(IntroFormState(introText: initialIntro?.value ?? '')) {
    _validateIntroText(state.introText);
  }
  final Ref ref;

  void introTextChanged(String value) {
    state = state.copyWith(introText: value, textChanged: true);
    _validateIntroText(value);
  }

  void _validateIntroText(String value) {
    state = state.copyWith(
      introError: value.trim().isEmpty ? 'Enter Introduction'.hardcoded : null,
    );
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);
    final data = Intro(id: id, value: state.introText.trim());
    final introController = ref.read(introControllerProvider.notifier);
    final result = id == null
        ? await introController.createIntro(data)
        : await introController.updateIntro(id, data);

    state = state.copyWith(isSubmitting: false);
    return result;
  }
}

final introFormProvider = StateNotifierProvider.autoDispose
    .family<IntroFormNotifier, IntroFormState, Intro?>(
      (ref, item) => IntroFormNotifier(ref, item),
    );
