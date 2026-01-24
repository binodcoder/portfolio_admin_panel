import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_scrollable_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/controller/skills_controller.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/ui/skill_validators.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SkillForm extends ConsumerStatefulWidget {
  const SkillForm({super.key, this.item});
  final Skill? item;

  @override
  ConsumerState<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends ConsumerState<SkillForm> with SkillValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  double _level = 50;

  String get name => _nameController.text;
  String get category => _categoryController.text;

  Skill? get skill => widget.item;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item?.name ?? '';
    _categoryController.text = widget.item?.category ?? '';
    _level = (widget.item?.level ?? 50).toDouble();
  }

  @override
  void dispose() {
    _node.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(skillsControllerProvider.notifier);

      final success = skill == null
          ? await controller.createSkill(name: name, level: _level, category: category)
          : await controller.updateSkill(
              data: skill!,
              name: name,
              level: _level,
              category: category,
            );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _nameEditingComplete() {
    if (canSubmitName(name)) {
      _node.nextFocus();
    }
  }

  void _categoryEditingComplete() {
    if (!canSubmitName(name)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(skillsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(skill != null ? 'Edit Skill'.hardcoded : 'New Skill'.hardcoded),
        actions: [
          SaveButton(
            onSave: state.isLoading ? null : () => _submit(),
            isLoading: state.isLoading,
          ),
        ],
      ),
      body: ResponsiveScrollableCard(
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => !_submitted ? null : nameErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _nameEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _categoryEditingComplete(),
                ),
                gapH12,
                Text('Level: ${_level.round()}%'),
                Slider(
                  value: _level,
                  onChanged: state.isLoading
                      ? null
                      : (value) => setState(() => _level = value),
                  min: 0,
                  max: 100,
                  divisions: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
