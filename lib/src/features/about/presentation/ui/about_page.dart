import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aboutControllerProvider);
    final action = ref.watch(aboutActionControllerProvider);

    Future<void> deleteItem() async {
      final items = state.asData?.value ?? const <About>[];
      if (items.isEmpty || items.first.id == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Nothing to delete')));
        return;
      }
      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete about?'),
              content: const Text('This action cannot be undone.'),
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
      if (!confirmed) return;
      await ref.read(aboutActionControllerProvider.notifier).deleteAbout(items.first.id!);
      if (!context.mounted) return;
      if (ref.read(aboutActionControllerProvider).hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Deleted')));
      }
    }

    void editItem() {
      final List<About> existing = state.asData?.value ?? const [];
      context.goNamed(
        AppRoute.aboutEdit.name,
        extra: existing.isNotEmpty ? existing.first : null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        actions: [
          TextButton.icon(
            onPressed: editItem,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: action.isLoading ? null : deleteItem,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: state.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error: $e'),
                ),
              ),
            ),
            data: (items) {
              final item = items.isNotEmpty ? items.first : null;
              if (item == null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(width: 12),
                          const Expanded(child: Text('No content yet')),
                          FilledButton.icon(
                            onPressed: editItem,
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
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SelectionArea(
                      child: Text(
                        item.value,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
