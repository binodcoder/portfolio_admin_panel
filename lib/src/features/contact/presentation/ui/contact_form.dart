import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_scrollable_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/controller/contact_controller.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/ui/contact_validators.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class ContactForm extends ConsumerStatefulWidget {
  const ContactForm({super.key, this.item});
  final ContactInfo? item;

  @override
  ConsumerState<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<ContactForm> with ContactValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _messageController = TextEditingController();

  bool _openToWork = true;

  String? get _id => widget.item?.id;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.item?.email ?? '';
    _phoneController.text = widget.item?.phone ?? '';
    _locationController.text = widget.item?.location ?? '';
    _websiteController.text = widget.item?.website ?? '';
    _messageController.text = widget.item?.message ?? '';
    _openToWork = widget.item?.openToWork ?? true;
  }

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(contactControllerProvider.notifier);
      final data = ContactInfo(
        id: _id,
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        openToWork: _openToWork,
        message: _messageController.text.trim().isEmpty
            ? null
            : _messageController.text.trim(),
      );
      final success =
          _id == null ? await controller.createContact(data) : await controller.updateContact(
            _id!,
            data,
          );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Contact'.hardcoded : 'New Contact'.hardcoded),
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : emailErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _node.nextFocus(),
                ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone'.hardcoded,
                          enabled: !state.isLoading,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            !_submitted ? null : phoneErrorText(value ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _node.nextFocus(),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location'.hardcoded,
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
                  controller: _websiteController,
                  decoration: InputDecoration(
                    labelText: 'Website'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      !_submitted ? null : websiteErrorText(value ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.url,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _node.nextFocus(),
                ),
                gapH8,
                Row(
                  children: [
                    Switch(
                      value: _openToWork,
                      onChanged: state.isLoading ? null : (value) => setState(
                        () => _openToWork = value,
                      ),
                    ),
                    gapW8,
                    Text('Open to work'.hardcoded),
                  ],
                ),
                gapH12,
                TextFormField(
                  controller: _messageController,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Contact message (optional)'.hardcoded,
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
