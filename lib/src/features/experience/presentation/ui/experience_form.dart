import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_controller.dart';

class ExperienceForm extends ConsumerStatefulWidget {
  const ExperienceForm({super.key, this.item});
  final Experience? item;
  @override
  ConsumerState<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends ConsumerState<ExperienceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _techsController;
  bool current = false;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final Experience? experience = widget.item;
    _companyController = TextEditingController(text: experience?.company);
    _titleController = TextEditingController(text: experience?.title);
    _locationController = TextEditingController(text: experience?.location);
    _startController = TextEditingController(text: experience?.start);
    _endController = TextEditingController(text: experience?.end);
    _descriptionController = TextEditingController(text: experience?.description);
    _techsController = TextEditingController(text: experience?.technologies.join(', '));
    current = experience == null ? false : experience.current;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _startController.dispose();
    _endController.dispose();
    _descriptionController.dispose();
    _techsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final techs = _techsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final data = Experience(
      id: _id,
      company: _companyController.text.trim(),
      title: _titleController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      start: _startController.text.trim().isEmpty ? null : _startController.text.trim(),
      end: current
          ? null
          : (_endController.text.trim().isEmpty ? null : _endController.text.trim()),
      current: current,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      technologies: techs,
    );
    final notifier = ref.read(experienceControllerProvider.notifier);
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
    final async = ref.watch(experienceControllerProvider);
    final canSave =
        !async.isLoading &&
        _companyController.text.trim().isNotEmpty &&
        _titleController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Experience' : 'New Experience'),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _companyController,
                            validator: (v) =>
                                (v ?? '').trim().isEmpty ? 'Enter company' : null,
                            decoration: const InputDecoration(labelText: 'Company'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _titleController,
                            validator: (v) =>
                                (v ?? '').trim().isEmpty ? 'Enter title/role' : null,
                            decoration: const InputDecoration(labelText: 'Title / Role'),
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
                            enabled: !current,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: current,
                          onChanged: (v) => setState(() {
                            current = v ?? false;
                            if (current) _endController.clear();
                          }),
                        ),
                        const Text('I currently work here'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location (optional)'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: null,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _techsController,
                      decoration: const InputDecoration(
                        labelText: 'Technologies (comma separated)',
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
