import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/projects_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectsControllerProvider);
    final action = ref.watch(projectsActionControllerProvider);

    Future<void> deleteItem(Project p) async {
      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete project?'),
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
      await ref.read(projectsActionControllerProvider.notifier).deleteProject(p.id!);
    }

    void createNew() => context.goNamed(AppRoute.projectEdit.name, extra: null);
    void editItem(Project p) => context.goNamed(AppRoute.projectEdit.name, extra: p);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
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
                          const Expanded(child: Text('No projects yet')),
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
                    for (final p in items)
                      Card(
                        child: ListTile(
                          title: Text(p.title),
                          subtitle: Text(p.description ?? 'No description'),
                          isThreeLine: true,
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                onPressed: () => editItem(p),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: action.isLoading || p.id == null
                                    ? null
                                    : () => deleteItem(p),
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
