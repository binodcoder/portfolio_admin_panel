import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/custom_text_form_field.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SocialForm extends ConsumerStatefulWidget {
  const SocialForm({super.key, this.item});
  final SocialLink? item;

  @override
  ConsumerState<SocialForm> createState() => _SocialFormState();
}

class _SocialFormState extends ConsumerState<SocialForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _platformController;
  late final TextEditingController _urlController;

  String? get _id => widget.item?.id;

  @override
  void initState() {
    super.initState();
    _platformController = TextEditingController(text: widget.item?.platform);
    _urlController = TextEditingController(text: widget.item?.url);
  }

  @override
  void dispose() {
    _platformController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final data = SocialLink(
      id: _id,
      platform: _platformController.text.trim(),
      url: _urlController.text.trim(),
    );
    final notifier = ref.read(socialControllerProvider.notifier);
    final didSave = _id == null
        ? await notifier.createSocial(data)
        : await notifier.updateSocial(_id!, data);
    if (!mounted || !didSave) return;
    context.pop();
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(socialControllerProvider.select((s) => s.isLoading));

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Link'.hardcoded : 'New Link'.hardcoded),
        actions: [
          TextButton.icon(
            onPressed: isLoading ? null : _save,
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_outlined),
            label: Text('Save'.hardcoded),
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
                    CustomTextFormField(
                      controller: _platformController,
                      validator: (v) =>
                          _requiredValidator(v, 'Enter Platform name'.hardcoded),
                      labelText: 'Platform (e.g. GitHub, LinkedIn)'.hardcoded,
                    ),
                    gapH12,
                    CustomTextFormField(
                      controller: _urlController,
                      validator: (v) => _requiredValidator(v, 'Enter URL'.hardcoded),
                      labelText: 'URL'.hardcoded,
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
