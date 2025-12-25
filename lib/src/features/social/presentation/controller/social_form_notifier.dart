import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_controller.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SocialFormNotifier extends StateNotifier<SocialFormState> {
  SocialFormNotifier(this.ref, SocialLink? initial)
    : super(SocialFormState(platform: initial?.platform ?? '', url: initial?.url ?? '')) {
    _validateAll();
  }

  final Ref ref;

  void platformChanged(String value) {
    state = state.copyWith(platform: value, textChanged: true);
    _validatePlatform(value);
  }

  void urlChanged(String value) {
    state = state.copyWith(url: value, textChanged: true);
    _validateUrl(value);
  }

  void _validatePlatform(String value) {
    state = state.copyWith(
      platformError: value.trim().isEmpty ? 'Enter Platform name'.hardcoded : null,
    );
  }

  void _validateUrl(String value) {
    state = state.copyWith(urlError: value.trim().isEmpty ? 'Enter URL'.hardcoded : null);
  }

  void _validateAll() {
    _validatePlatform(state.platform);
    _validateUrl(state.url);
  }

  Future<bool> submit({String? id}) async {
    _validateAll();

    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);

    final data = SocialLink(
      id: id,
      platform: state.platform.trim(),
      url: state.url.trim(),
    );

    final controller = ref.read(socialControllerProvider.notifier);

    final success = id == null
        ? await controller.createSocial(data)
        : await controller.updateSocial(id, data);

    state = state.copyWith(isSubmitting: false);
    return success;
  }
}

final socialFormProvider = StateNotifierProvider.autoDispose
    .family<SocialFormNotifier, SocialFormState, SocialLink?>(
      (ref, item) => SocialFormNotifier(ref, item),
    );
