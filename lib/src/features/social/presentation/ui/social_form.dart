import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_form_notifier.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_form_state.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SocialForm extends ConsumerWidget {
  const SocialForm({super.key, this.item});

  final SocialLink? item;
  String? get _id => item?.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialFormProvider(item));
    final notifier = ref.read(socialFormProvider(item).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Link'.hardcoded : 'New Link'.hardcoded),
        actions: [
          TextButton.icon(
            onPressed: !state.canSubmit
                ? null
                : () async {
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
              child: Column(
                children: [
                  TextField(
                    controller: TextEditingController(
                      text: state.platform,
                    )..selection = TextSelection.collapsed(offset: state.platform.length),
                    onChanged: notifier.platformChanged,
                    decoration: InputDecoration(
                      labelText: 'Platform (e.g. GitHub, LinkedIn)'.hardcoded,
                      errorText: state.platformError,
                    ),
                    enabled: !state.isSubmitting,
                  ),
                  gapH12,
                  TextField(
                    controller: TextEditingController(text: state.url)
                      ..selection = TextSelection.collapsed(offset: state.url.length),
                    onChanged: notifier.urlChanged,
                    decoration: InputDecoration(
                      labelText: 'URL'.hardcoded,
                      errorText: state.urlError,
                    ),
                    enabled: !state.isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
