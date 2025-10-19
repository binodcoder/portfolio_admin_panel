import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/skills_controller.dart';

class SkillForm extends ConsumerStatefulWidget {
  const SkillForm({super.key, this.item});
  final Skill? item;

  @override
  ConsumerState<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends ConsumerState<SkillForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  double level = 50;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final s = widget.item;
    if (s != null) {
      nameController.text = s.name;
      categoryController.text = s.category ?? '';
      level = s.level.toDouble();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = Skill(
      id: _id,
      name: nameController.text.trim(),
      level: level.round(),
      category: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
    );
    final notifier = ref.read(skillsActionControllerProvider.notifier);
    if (_id == null) {
      await notifier.createSkill(data);
    } else {
      await notifier.updateSkill(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(skillsActionControllerProvider);
    final canSave = !async.isLoading && nameController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Skill' : 'New Skill'),
        actions: [
          TextButton.icon(
            onPressed: canSave ? _save : null,
            icon: async.isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (v) => (v ?? '').trim().isEmpty ? 'Enter skill name' : null,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: categoryController,
                        decoration: const InputDecoration(labelText: 'Category (optional)'),
                      ),
                      const SizedBox(height: 12),
                      Text('Level: ${level.round()}%'),
                      Slider(
                        value: level,
                        onChanged: (v) => setState(() => level = v),
                        min: 0,
                        max: 100,
                        divisions: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
