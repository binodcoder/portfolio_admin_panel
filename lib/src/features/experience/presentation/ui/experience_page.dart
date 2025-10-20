import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class ExperiencePage extends ConsumerWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(experienceControllerProvider);
    final action = ref.watch(experienceActionControllerProvider);

    Future<void> deleteItem(Experience e) async {
      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete experience?'),
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
      await ref.read(experienceActionControllerProvider.notifier).deleteExperience(e.id!);
    }

    void createNew() => context.goNamed(AppRoute.experienceEdit.name, extra: null);
    void editItem(Experience e) =>
        context.goNamed(AppRoute.experienceEdit.name, extra: e);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience'),
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
          constraints: const BoxConstraints(maxWidth: 1100),
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
                          const Expanded(child: Text('No experience added yet')),
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
                    for (final e in items)
                      Card(
                        child: ListTile(
                          title: Text('${e.title} • ${e.company}'),
                          subtitle: Text(
                            '${e.start ?? ''} - ${e.current ? 'Present' : (e.end ?? '')}${e.location != null ? ' • ${e.location}' : ''}',
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                onPressed: () => editItem(e),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: action.isLoading || e.id == null
                                    ? null
                                    : () => deleteItem(e),
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
