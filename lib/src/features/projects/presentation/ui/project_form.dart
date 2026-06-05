import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/responsive_scrollable_card.dart';
import 'package:binodfolioadmin/src/common_widgets/save_button.dart';
import 'package:binodfolioadmin/src/constants/app_sizes.dart';
import 'package:binodfolioadmin/src/features/projects/domain/project.dart';
import 'package:binodfolioadmin/src/features/projects/presentation/controller/projects_controller.dart';
import 'package:binodfolioadmin/src/features/projects/presentation/ui/project_validators.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key, this.item});
  final Project? item;

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> with ProjectValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repoUrlController = TextEditingController();
  final _liveUrlController = TextEditingController();
  final _tagsController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;
  String get repoUrl => _repoUrlController.text;
  String get liveUrl => _liveUrlController.text;
  String get tags => _tagsController.text;

  Project? get project => widget.item;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.item?.title ?? '';
    _descriptionController.text = widget.item?.description ?? '';
    _repoUrlController.text = widget.item?.repoUrl ?? '';
    _liveUrlController.text = widget.item?.liveUrl ?? '';
    _tagsController.text = (widget.item?.tags ?? const <String>[]).join(', ');
  }

  @override
  void dispose() {
    _node.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _repoUrlController.dispose();
    _liveUrlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(projectsControllerProvider.notifier);

      final success = project == null
          ? await controller.createProject(
              title: title,
              description: description,
              repoUrl: repoUrl,
              liveUrl: liveUrl,
              tags: tags,
            )
          : await controller.updateProject(
              data: project!,
              title: title,
              description: description,
              repoUrl: repoUrl,
              liveUrl: liveUrl,
              tags: tags,
            );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _titleEditingComplete() {
    if (canSubmitTitle(title)) {
      _node.nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(project != null ? 'Edit Project'.hardcoded : 'New Project'.hardcoded),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => !_submitted ? null : titleErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _titleEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Description'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autocorrect: false,
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.multiline,
                ),
                gapH12,
                TextFormField(
                  controller: _repoUrlController,
                  decoration: InputDecoration(
                    labelText: 'Repository URL (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : repoUrlErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.url,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _node.nextFocus(),
                ),
                gapH12,
                TextFormField(
                  controller: _liveUrlController,
                  decoration: InputDecoration(
                    labelText: 'Live URL (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : liveUrlErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.url,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _node.nextFocus(),
                ),
                gapH12,
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: 'Tags (comma separated)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _submit(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
