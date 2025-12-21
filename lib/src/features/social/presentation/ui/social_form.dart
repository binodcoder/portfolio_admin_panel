import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_form_notifier.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SocialForm extends ConsumerWidget {
  SocialForm({super.key, this.item});
  final SocialLink? item;

  String? get _id => item?.id;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialFormProvider(item));
    final notifier = ref.read(socialFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Link'.hardcoded : 'New Link'.hardcoded),
        actions: [
          TextButton.icon(
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    final success = await notifier.submit(id: _id);

                    if (context.mounted && success) {
                      context.pop();
                    }
                  },

            icon: state.isSubmitting
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
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: state.platform,
                      onChanged: notifier.platformChanged,
                      decoration: InputDecoration(
                        labelText: 'Platform (e.g. GitHub, LinkedIn)'.hardcoded,
                      ),

                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Enter Platform name'.hardcoded
                          : null,
                    ),
                    gapH12,
                    TextFormField(
                      initialValue: state.url,
                      onChanged: notifier.urlChanged,
                      decoration: InputDecoration(labelText: 'URL'.hardcoded),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Enter URL'.hardcoded : null,
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
