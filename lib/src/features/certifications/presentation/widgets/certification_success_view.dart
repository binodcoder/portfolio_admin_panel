import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';
import 'package:portfolio_admin_panel/src/utils/async_value_ui.dart';

class CertificationSuccessView extends ConsumerWidget {
  const CertificationSuccessView({super.key, required this.items});

  final List<Certification> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(certificationControllerProvider);

    ref.listen(
      certificationControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    void editItem(Certification c) =>
        context.goNamed(AppRoute.certificationEdit.name, extra: c);

    String subtitleFor(Certification c) {
      final date = (c.issueDate ?? '').isNotEmpty ? ' • ${c.issueDate}' : '';
      final issuer = c.issuer ?? '';
      return '$issuer$date';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final c = items[i];
          return Card(
            key: ValueKey(c.id ?? c.name),
            child: ListTile(
              title: Text(c.name),
              subtitle: Text(subtitleFor(c)),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    tooltip: 'Edit'.hardcoded,
                    onPressed: () => editItem(c),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Delete'.hardcoded,
                    onPressed: action.isLoading || c.id == null
                        ? null
                        : () async {
                            final delete = await showAlertDialog(
                              context: context,
                              title: 'Are you sure?'.hardcoded,
                              cancelActionText: 'Cancel'.hardcoded,
                              defaultActionText: 'Delete'.hardcoded,
                            );
                            if (delete == true) {
                              await ref
                                  .read(certificationControllerProvider.notifier)
                                  .deleteCertification(c.id!);
                            }
                          },

                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
