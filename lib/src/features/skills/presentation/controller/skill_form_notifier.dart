import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/controller/skills_controller.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/controller/skill_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SkillFormNotifier extends StateNotifier<SkillFormState> {
  SkillFormNotifier(this.ref, Skill? initial)
    : super(
        SkillFormState(
          name: initial?.name ?? '',
          category: initial?.category ?? '',
          level: (initial?.level ?? 50).toDouble(),
        ),
      ) {
    _validateName(state.name);
  }

  final Ref ref;

  void nameChanged(String value) {
    state = state.copyWith(name: value, textChanged: true);
    _validateName(value);
  }

  void _validateName(String value) {
    state = state.copyWith(
      nameError: value.trim().isEmpty ? 'Enter skill name'.hardcoded : null,
    );
  }

  void categoryChanged(String value) {
    state = state.copyWith(category: value, textChanged: true);
  }

  void levelChanged(double value) {
    state = state.copyWith(level: value, textChanged: true);
  }

  Future<bool> submit({String? id}) async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true);
    final data = Skill(
      id: id,
      name: state.name.trim(),
      level: state.level.round(),
      category: state.category.trim().isEmpty ? null : state.category.trim(),
    );

    final controller = ref.read(skillsControllerProvider.notifier);
    final success =
        id == null ? await controller.createSkill(data) : await controller.updateSkill(
          id,
          data,
        );

    state = state.copyWith(isSubmitting: false);
    return success;
  }
}

final skillFormProvider = StateNotifierProvider.autoDispose
    .family<SkillFormNotifier, SkillFormState, Skill?>(
      (ref, item) => SkillFormNotifier(ref, item),
    );
