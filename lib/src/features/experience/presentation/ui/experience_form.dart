import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/experience_controller.dart';

class ExperienceForm extends ConsumerStatefulWidget {
  const ExperienceForm({super.key, this.item});
  final Experience? item;
  @override
  ConsumerState<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends ConsumerState<ExperienceForm> {
  final _formKey = GlobalKey<FormState>();
  final companyController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final descriptionController = TextEditingController();
  final techsController = TextEditingController();
  bool current = false;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final e = widget.item;
    if (e != null) {
      companyController.text = e.company;
      titleController.text = e.title;
      locationController.text = e.location ?? '';
      startController.text = e.start ?? '';
      endController.text = e.end ?? '';
      descriptionController.text = e.description ?? '';
      techsController.text = e.technologies.join(', ');
      current = e.current;
    }
    // Rebuild when fields change so Save button updates
    companyController.addListener(() => setState(() {}));
    titleController.addListener(() => setState(() {}));
    locationController.addListener(() => setState(() {}));
    startController.addListener(() => setState(() {}));
    endController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
    techsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    companyController.dispose();
    titleController.dispose();
    locationController.dispose();
    startController.dispose();
    endController.dispose();
    descriptionController.dispose();
    techsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final techs = techsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final data = Experience(
      id: _id,
      company: companyController.text.trim(),
      title: titleController.text.trim(),
      location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
      start: startController.text.trim().isEmpty ? null : startController.text.trim(),
      end: current ? null : (endController.text.trim().isEmpty ? null : endController.text.trim()),
      current: current,
      description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
      technologies: techs,
    );
    final notifier = ref.read(experienceActionControllerProvider.notifier);
    if (_id == null) {
      await notifier.createExperience(data);
    } else {
      await notifier.updateExperience(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(experienceActionControllerProvider);
    final canSave = !async.isLoading && companyController.text.trim().isNotEmpty && titleController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Experience' : 'New Experience'),
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
          constraints: const BoxConstraints(maxWidth: 1000),
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
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            controller: companyController,
                            validator: (v) => (v ?? '').trim().isEmpty ? 'Enter company' : null,
                            decoration: const InputDecoration(labelText: 'Company'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: titleController,
                            validator: (v) => (v ?? '').trim().isEmpty ? 'Enter title/role' : null,
                            decoration: const InputDecoration(labelText: 'Title / Role'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            controller: startController,
                            decoration: const InputDecoration(labelText: 'Start (YYYY-MM)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: endController,
                            decoration: const InputDecoration(labelText: 'End (YYYY-MM)'),
                            enabled: !current,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        Checkbox(
                          value: current,
                          onChanged: (v) => setState(() {
                            current = v ?? false;
                            if (current) endController.clear();
                          }),
                        ),
                        const Text('I currently work here'),
                      ]),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(labelText: 'Location (optional)'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        minLines: 4,
                        maxLines: null,
                        decoration: const InputDecoration(labelText: 'Description'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: techsController,
                        decoration: const InputDecoration(labelText: 'Technologies (comma separated)'),
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
