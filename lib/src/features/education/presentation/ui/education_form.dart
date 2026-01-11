import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_scrollable_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_controller.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/ui/education_validators.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class EducationForm extends ConsumerStatefulWidget {
  const EducationForm({super.key, this.item});
  final Education? item;

  @override
  ConsumerState<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends ConsumerState<EducationForm> with EducationValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _locationController = TextEditingController();
  final _gpaController = TextEditingController();
  final _descriptionController = TextEditingController();

  String get institution => _institutionController.text;

  String? get _id => widget.item?.id;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _institutionController.text = widget.item?.institution ?? '';
    _degreeController.text = widget.item?.degree ?? '';
    _fieldController.text = widget.item?.field ?? '';
    _startController.text =
        widget.item?.start == null ? '' : _formatDate(widget.item!.start!);
    _endController.text =
        widget.item?.end == null ? '' : _formatDate(widget.item!.end!);
    _locationController.text = widget.item?.location ?? '';
    _gpaController.text = widget.item?.gpa ?? '';
    _descriptionController.text = widget.item?.description ?? '';
  }

  @override
  void dispose() {
    _node.dispose();
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

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(educationControllerProvider.notifier);
      final data = Education(
        id: _id,
        institution: _institutionController.text.trim(),
        degree: _degreeController.text.trim().isEmpty
            ? null
            : _degreeController.text.trim(),
        field: _fieldController.text.trim().isEmpty ? null : _fieldController.text.trim(),
        start: _startController.text.trim().isEmpty
            ? null
            : DateTime.parse(_startController.text.trim()),
        end: _endController.text.trim().isEmpty
            ? null
            : DateTime.parse(_endController.text.trim()),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        gpa: _gpaController.text.trim().isEmpty ? null : _gpaController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      final success =
          _id == null ? await controller.createEducation(data) : await controller
              .updateEducation(_id!, data);
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _institutionEditingComplete() {
    if (canSubmitInstitution(institution)) {
      _node.nextFocus();
    }
  }

  String _formatDate(DateTime date) =>
      date.toIso8601String().split('T').first;

  DateTime _initialDate(String value) =>
      DateTime.tryParse(value.trim()) ?? DateTime.now();

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _initialDate(controller.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = _formatDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(educationControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Education'.hardcoded : 'New Education'.hardcoded),
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
                  controller: _institutionController,
                  decoration: InputDecoration(
                    labelText: 'Institution'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : institutionErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _institutionEditingComplete(),
                ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _degreeController,
                        decoration: InputDecoration(
                          labelText: 'Degree (e.g., BSc)'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextFormField(
                        controller: _fieldController,
                        decoration: InputDecoration(
                          labelText: 'Field of study'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                  ],
                ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startController,
                        decoration: InputDecoration(
                          labelText: 'Start Date'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            !_submitted ? null : startErrorText(value ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        readOnly: true,
                        onTap: state.isLoading ? null : () => _selectDate(_startController),
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextFormField(
                        controller: _endController,
                        decoration: InputDecoration(
                          labelText: 'End Date'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => !_submitted ? null : endErrorText(value ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        readOnly: true,
                        onTap: state.isLoading ? null : () => _selectDate(_endController),
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                  ],
                ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location (optional)'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextFormField(
                        controller: _gpaController,
                        decoration: InputDecoration(
                          labelText: 'GPA (optional)'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                  ],
                ),
                gapH12,
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autocorrect: false,
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
