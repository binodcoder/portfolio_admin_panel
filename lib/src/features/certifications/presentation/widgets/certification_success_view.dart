import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class CertificationSuccessView extends ConsumerWidget {
  const CertificationSuccessView({
    super.key,
    required this.items,
    required this.onCreate,
  });

  final List<Certification> items;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(certificationControllerProvider);

    // Listen for action errors and show a SnackBar
    ref.listen(certificationControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Operation failed: $e'))),
      );
    });

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
      await ref.read(certificationControllerProvider.notifier).deleteCertification(c.id!);
    }

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
                    tooltip: 'Edit',
                    onPressed: () => editItem(c),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: action.isLoading || c.id == null
                        ? null
                        : () => deleteItem(c),
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
