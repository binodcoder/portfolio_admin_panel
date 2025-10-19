import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/projects_controller.dart';

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key, this.item});
  final Project? item;
  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final repoController = TextEditingController();
  final liveController = TextEditingController();
  final tagsController = TextEditingController();

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    final p = widget.item;
    if (p != null) {
      titleController.text = p.title;
      descController.text = p.description ?? '';
      repoController.text = p.repoUrl ?? '';
      liveController.text = p.liveUrl ?? '';
      tagsController.text = p.tags.join(', ');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    repoController.dispose();
    liveController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final tags = tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final data = Project(
      id: _id,
      title: titleController.text.trim(),
      description: descController.text.trim().isEmpty ? null : descController.text.trim(),
      repoUrl: repoController.text.trim().isNotEmpty ? repoController.text.trim() : null,
      liveUrl: liveController.text.trim().isNotEmpty ? liveController.text.trim() : null,
      tags: tags,
    );
    final notifier = ref.read(projectsActionControllerProvider.notifier);
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
    final async = ref.watch(projectsActionControllerProvider);
    final canSave = !async.isLoading && titleController.text.trim().isNotEmpty;
    final isEditing = _id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Project' : 'New Project'),
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
                      TextFormField(
                        controller: titleController,
                        validator: (v) => (v ?? '').trim().isEmpty ? 'Enter title' : null,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descController,
                        minLines: 4,
                        maxLines: null,
                        decoration: const InputDecoration(labelText: 'Description'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: repoController,
                        decoration: const InputDecoration(labelText: 'Repository URL (optional)'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: liveController,
                        decoration: const InputDecoration(labelText: 'Live URL (optional)'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: tagsController,
                        decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
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
