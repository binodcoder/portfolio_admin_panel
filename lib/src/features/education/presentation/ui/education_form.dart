import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_controller.dart';

class EducationForm extends ConsumerStatefulWidget {
  const EducationForm({super.key, this.item});
  final Education? item;
  @override
  ConsumerState<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends ConsumerState<EducationForm> {
  final _formKey = GlobalKey<FormState>();
  final institutionController = TextEditingController();
  final degreeController = TextEditingController();
  final fieldController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final locationController = TextEditingController();
  final gpaController = TextEditingController();
  final descriptionController = TextEditingController();

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final e = widget.item;
    if (e != null) {
      institutionController.text = e.institution;
      degreeController.text = e.degree ?? '';
      fieldController.text = e.field ?? '';
      startController.text = e.start ?? '';
      endController.text = e.end ?? '';
      locationController.text = e.location ?? '';
      gpaController.text = e.gpa ?? '';
      descriptionController.text = e.description ?? '';
    }
    // Rebuild when fields change so Save button updates
    institutionController.addListener(() => setState(() {}));
    degreeController.addListener(() => setState(() {}));
    fieldController.addListener(() => setState(() {}));
    startController.addListener(() => setState(() {}));
    endController.addListener(() => setState(() {}));
    locationController.addListener(() => setState(() {}));
    gpaController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    institutionController.dispose();
    degreeController.dispose();
    fieldController.dispose();
    startController.dispose();
    endController.dispose();
    locationController.dispose();
    gpaController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = Education(
      id: _id,
      institution: institutionController.text.trim(),
      degree: degreeController.text.trim().isEmpty ? null : degreeController.text.trim(),
      field: fieldController.text.trim().isEmpty ? null : fieldController.text.trim(),
      start: startController.text.trim().isEmpty ? null : startController.text.trim(),
      end: endController.text.trim().isEmpty ? null : endController.text.trim(),
      location: locationController.text.trim().isEmpty
          ? null
          : locationController.text.trim(),
      gpa: gpaController.text.trim().isEmpty ? null : gpaController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
    );
    final notifier = ref.read(educationActionControllerProvider.notifier);
    if (_id == null) {
      await notifier.createEducation(data);
    } else {
      await notifier.updateEducation(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(educationActionControllerProvider);
    final canSave = !async.isLoading && institutionController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Education' : 'New Education'),
        actions: [
          TextButton.icon(
            onPressed: canSave ? _save : null,
            icon: async.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
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
                      TextFormField(
                        controller: institutionController,
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? 'Enter institution' : null,
                        decoration: const InputDecoration(labelText: 'Institution'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: degreeController,
                              decoration: const InputDecoration(
                                labelText: 'Degree (e.g., BSc)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: fieldController,
                              decoration: const InputDecoration(
                                labelText: 'Field of study',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: startController,
                              decoration: const InputDecoration(
                                labelText: 'Start (YYYY-MM)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: endController,
                              decoration: const InputDecoration(
                                labelText: 'End (YYYY-MM)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: locationController,
                              decoration: const InputDecoration(
                                labelText: 'Location (optional)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: gpaController,
                              decoration: const InputDecoration(
                                labelText: 'GPA (optional)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Description (optional)',
                        ),
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
