import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/skills_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class SkillsPage extends ConsumerWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(skillsControllerProvider);
    final action = ref.watch(skillsActionControllerProvider);

    Future<void> deleteItem(Skill s) async {
      final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete skill?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
              ],
            ),
          ) ??
          false;
      if (!confirm) return;
      await ref.read(skillsActionControllerProvider.notifier).deleteSkill(s.id!);
    }

    void createNew() => context.goNamed(AppRoute.skillEdit.name, extra: null);
    void editItem(Skill s) => context.goNamed(AppRoute.skillEdit.name, extra: s);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
        actions: [
          TextButton.icon(onPressed: createNew, icon: const Icon(Icons.add_outlined), label: const Text('New')),
          const SizedBox(width: 8),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: state.when(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('No skills yet')),
                        FilledButton.icon(onPressed: createNew, icon: const Icon(Icons.add_outlined), label: const Text('Add'))
                      ]),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(builder: (context, constraints) {
                  final isTable = constraints.maxWidth > 700;
                  if (!isTable) {
                    return Column(
                      children: [
                        for (final s in items)
                          Card(
                            child: ListTile(
                              title: Text(s.name),
                              subtitle: Text('${s.category ?? 'General'} • ${s.level}%'),
                              trailing: Wrap(spacing: 8, children: [
                                IconButton(onPressed: () => editItem(s), icon: const Icon(Icons.edit_outlined)),
                                IconButton(
                                  onPressed: action.isLoading || s.id == null ? null : () => deleteItem(s),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ]),
                            ),
                          )
                      ],
                    );
                  }
                  return DataTable(columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Level')),
                    DataColumn(label: Text('Actions')),
                  ], rows: [
                    for (final s in items)
                      DataRow(cells: [
                        DataCell(Text(s.name)),
                        DataCell(Text(s.category ?? '-')),
                        DataCell(Text('${s.level}%')),
                        DataCell(Row(children: [
                          IconButton(onPressed: () => editItem(s), icon: const Icon(Icons.edit_outlined)),
                          IconButton(
                            onPressed: action.isLoading || s.id == null ? null : () => deleteItem(s),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ])),
                      ])
                  ]);
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
