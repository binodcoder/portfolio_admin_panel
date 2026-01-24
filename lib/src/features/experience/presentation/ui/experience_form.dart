import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_scrollable_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_controller.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/ui/experience_validators.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ExperienceForm extends ConsumerStatefulWidget {
  const ExperienceForm({super.key, this.item});
  final Experience? item;

  @override
  ConsumerState<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends ConsumerState<ExperienceForm>
    with ExperienceValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _companyController = TextEditingController();
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();

  bool _current = false;

  String get company => _companyController.text.trim();
  String get title => _titleController.text.trim();
  String get start => _startController.text.trim();
  String get end => _endController.text.trim();
  String get location => _locationController.text.trim();
  String get description => _descriptionController.text.trim();
  String get technologies => _technologiesController.text.trim();

  Experience? get experience => widget.item;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _companyController.text = widget.item?.company ?? '';
    _titleController.text = widget.item?.title ?? '';
    _startController.text = widget.item?.start == null
        ? ''
        : _formatDate(widget.item!.start!);
    _endController.text = widget.item?.end == null ? '' : _formatDate(widget.item!.end!);
    _locationController.text = widget.item?.location ?? '';
    _descriptionController.text = widget.item?.description ?? '';
    _technologiesController.text = (widget.item?.technologies ?? const <String>[]).join(
      ', ',
    );
    _current = widget.item?.current ?? false;
  }

  @override
  void dispose() {
    _node.dispose();
    _companyController.dispose();
    _titleController.dispose();
    _startController.dispose();
    _endController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(experienceControllerProvider.notifier);

      final success = experience == null
          ? await controller.createExperience(
              company: company,
              title: title,
              location: location,
              start: start,
              end: end,
              current: _current,
              description: description,
              technologies: technologies,
            )
          : await controller.updateExperience(
              data: experience!,
              company: company,
              title: title,
              location: location,
              start: start,
              end: end,
              current: _current,
              description: description,
              technologies: technologies,
            );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _companyEditingComplete() {
    if (canSubmitCompany(company)) {
      _node.nextFocus();
    }
  }

  void _titleEditingComplete() {
    if (canSubmitTitle(title)) {
      _node.nextFocus();
    }
  }

  void _locationEditingComplete() {
    if (canSubmitLocation(location)) {
      _node.nextFocus();
    }
  }

  void _startEditingComplete() {
    if (canSubmitStart(start)) {
      _node.nextFocus();
    }
  }

  void _endEditingComplete() {
    if (canSubmitEnd(isCurrent: _current, end)) {
      _node.nextFocus();
    }
  }

  void _descriptionEditingComplete() {
    if (canSubmitDescription(description)) {
      _node.nextFocus();
    }
  }

  void _technologyEditingComplete() {
    if (canSubmitTechnology(technologies)) {
      _submit();
    }
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

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
    final state = ref.watch(experienceControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          experience != null ? 'Edit Experience'.hardcoded : 'New Experience'.hardcoded,
        ),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _companyController,
                        decoration: InputDecoration(
                          labelText: 'Company'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            !_submitted ? null : companyErrorText(value ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _companyEditingComplete(),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title / Role'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            !_submitted ? null : titleErrorText(value ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _titleEditingComplete(),
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
                        onTap: state.isLoading
                            ? null
                            : () => _selectDate(_startController),
                        onEditingComplete: () => _startEditingComplete(),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextFormField(
                        controller: _endController,
                        decoration: InputDecoration(
                          labelText: 'End Date'.hardcoded,
                          enabled: !state.isLoading && !_current,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => !_submitted
                            ? null
                            : endErrorText(value ?? '', isCurrent: _current),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        readOnly: true,
                        onTap: state.isLoading || _current
                            ? null
                            : () => _selectDate(_endController),
                        onEditingComplete: () => _endEditingComplete(),
                      ),
                    ),
                  ],
                ),
                gapH8,
                Row(
                  children: [
                    Checkbox(
                      value: _current,
                      onChanged: state.isLoading
                          ? null
                          : (value) => setState(() {
                              _current = value ?? false;
                              if (_current) {
                                _endController.clear();
                              }
                            }),
                    ),
                    Text('I currently work here'.hardcoded),
                  ],
                ),
                gapH12,
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location (optional)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : locationErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _locationEditingComplete(),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : descriptionErrorText(value ?? ''),
                  autocorrect: false,
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.multiline,
                  onEditingComplete: () => _descriptionEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  controller: _technologiesController,
                  decoration: InputDecoration(
                    labelText: 'Technologies (comma separated)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : technologyErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _technologyEditingComplete(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
