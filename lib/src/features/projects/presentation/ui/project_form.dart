import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/projects_controller.dart';

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key, this.item});
  final Project? item;
  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _repoController;
  late final TextEditingController _liveController;
  late final TextEditingController _tagsController;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final Project? project = widget.item;

    _titleController = TextEditingController(text: project?.title);
    _descController = TextEditingController(text: project?.description);
    _repoController = TextEditingController(text: project?.repoUrl);
    _liveController = TextEditingController(text: project?.liveUrl);
    _tagsController = TextEditingController(text: project?.tags.join(', ') ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _repoController.dispose();
    _liveController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final data = Project(
      id: _id,
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      repoUrl: _repoController.text.trim().isNotEmpty
          ? _repoController.text.trim()
          : null,
      liveUrl: _liveController.text.trim().isNotEmpty
          ? _liveController.text.trim()
          : null,
      tags: tags,
    );
    final notifier = ref.read(projectsControllerProvider.notifier);
    if (_id == null) {
      await notifier.createProject(data);
    } else {
      await notifier.updateProject(_id!, data);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(projectsControllerProvider);
    // final canSave = !async.isLoading && _titleController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Project' : 'New Project'),
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
                      controller: _titleController,
                      validator: (v) => (v ?? '').trim().isEmpty ? 'Enter title' : null,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descController,
                      minLines: 4,
                      maxLines: null,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _repoController,
                      decoration: const InputDecoration(
                        labelText: 'Repository URL (optional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _liveController,
                      decoration: const InputDecoration(labelText: 'Live URL (optional)'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags (comma separated)',
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
