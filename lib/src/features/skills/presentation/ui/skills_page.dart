import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/skills/data/skills_repository.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/controller/skills_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    void createNew() => context.goNamed(AppRoute.skillEdit.name, extra: null);
    return AppBar(
      title: Text('Skills'.hardcoded),
      actions: [
        TextButton.icon(
          onPressed: createNew,
          icon: const Icon(Icons.add_outlined),
          label: Text('New'.hardcoded),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(skillListProvider);

    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: AsyncValueWidget(
          value: state,
          data: (items) => items.isEmpty
              ? EmptyState(
                  title: "No skills yet".hardcoded,
                  subTitle: "Try adding skills".hardcoded,
                )
              : SkillSuccessView(items: items),
        ),
      ),
    );
  }
}

class SkillSuccessView extends ConsumerWidget {
  const SkillSuccessView({super.key, required this.items});

  final List<Skill> items;

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );

    if (confirm == true) {
      await ref.read(skillsControllerProvider.notifier).deleteSkill(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsController = ref.watch(skillsControllerProvider);

    void editItem(Skill s) => context.goNamed(AppRoute.skillEdit.name, extra: s);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTable = constraints.maxWidth > 700;
          if (!isTable) {
            return Column(
              children: [
                for (final s in items)
                  Card(
                    child: ListTile(
                      title: Text(s.name),
                      subtitle: Text('${s.category ?? 'General'} • ${s.level}%'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            onPressed: () => editItem(s),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: (skillsController.isLoading || s.id == null)
                                ? null
                                : () => _confirmAndDelete(context, ref, s.id!),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
          return DataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Actions')),
            ],
            rows: [
              for (final s in items)
                DataRow(
                  cells: [
                    DataCell(Text(s.name)),
                    DataCell(Text(s.category ?? '-')),
                    DataCell(Text('${s.level}%')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => editItem(s),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: (skillsController.isLoading || s.id == null)
                                ? null
                                : () => _confirmAndDelete(context, ref, s.id!),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
