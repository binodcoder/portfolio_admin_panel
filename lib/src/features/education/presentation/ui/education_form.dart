import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
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
  late final TextEditingController _institutionController;
  late final TextEditingController _degreeController;
  late final TextEditingController _fieldController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _locationController;
  late final TextEditingController _gpaController;
  late final TextEditingController _descriptionController;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final Education? education = widget.item;

    _institutionController = TextEditingController(text: education?.institution);
    _degreeController = TextEditingController(text: education?.degree);
    _fieldController = TextEditingController(text: education?.field);
    _startController = TextEditingController(text: education?.start);
    _endController = TextEditingController(text: education?.end);
    _locationController = TextEditingController(text: education?.location);
    _gpaController = TextEditingController(text: education?.gpa);
    _descriptionController = TextEditingController(text: education?.description);
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _startController.dispose();
    _endController.dispose();
    _locationController.dispose();
    _gpaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = Education(
      id: _id,
      institution: _institutionController.text.trim(),
      degree: _degreeController.text.trim().isEmpty
          ? null
          : _degreeController.text.trim(),
      field: _fieldController.text.trim().isEmpty ? null : _fieldController.text.trim(),
      start: _startController.text.trim().isEmpty ? null : _startController.text.trim(),
      end: _endController.text.trim().isEmpty ? null : _endController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      gpa: _gpaController.text.trim().isEmpty ? null : _gpaController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );
    final notifier = ref.read(educationControllerProvider.notifier);
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
    final async = ref.watch(educationControllerProvider);
    //  final canSave = !async.isLoading && _institutionController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Education' : 'New Education'),
        actions: [
          TextButton.icon(
            onPressed: _save,
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
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _institutionController,
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Enter institution' : null,
                      decoration: const InputDecoration(labelText: 'Institution'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _degreeController,
                            decoration: const InputDecoration(
                              labelText: 'Degree (e.g., BSc)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _fieldController,
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
                            controller: _startController,
                            decoration: const InputDecoration(
                              labelText: 'Start (YYYY-MM)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _endController,
                            decoration: const InputDecoration(labelText: 'End (YYYY-MM)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location (optional)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _gpaController,
                            decoration: const InputDecoration(
                              labelText: 'GPA (optional)',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
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
    );
  }
}
