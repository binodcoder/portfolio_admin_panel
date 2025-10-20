import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class CertificationsPage extends ConsumerWidget {
  const CertificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(certificationsControllerProvider);
    final action = ref.watch(certificationsActionControllerProvider);

    Future<void> deleteItem(Certification c) async {
      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete certification?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirm) return;
      await ref
          .read(certificationsActionControllerProvider.notifier)
          .deleteCertification(c.id!);
    }

    void createNew() => context.goNamed(AppRoute.certificationEdit.name, extra: null);
    void editItem(Certification c) =>
        context.goNamed(AppRoute.certificationEdit.name, extra: c);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certifications'),
        actions: [
          TextButton.icon(
            onPressed: createNew,
            icon: const Icon(Icons.add_outlined),
            label: const Text('New'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: state.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(width: 8),
                          const Expanded(child: Text('No certifications yet')),
                          FilledButton.icon(
                            onPressed: createNew,
                            icon: const Icon(Icons.add_outlined),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (final c in items)
                      Card(
                        child: ListTile(
                          title: Text(c.name),
                          subtitle: Text(
                            '${c.issuer ?? ''}${(c.issueDate ?? '').isNotEmpty ? ' • ${c.issueDate}' : ''}',
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                onPressed: () => editItem(c),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: action.isLoading || c.id == null
                                    ? null
                                    : () => deleteItem(c),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
