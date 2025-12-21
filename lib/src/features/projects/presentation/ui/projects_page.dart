import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/projects/data/projects_repository.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/controller/projects_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

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
    return AppBar(
      title: const Text('Projects'),
      actions: [
        TextButton.icon(
          onPressed: () => context.goNamed(AppRoute.projectEdit.name, extra: null),
          icon: const Icon(Icons.add_outlined),
          label: const Text('New'),
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
    final state = ref.watch(projectListProvider);

    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: AsyncValueWidget(
          value: state,
          data: (items) => items.isEmpty
              ? EmptyState(
                  title: "No project yet".hardcoded,
                  subTitle: "Try adding project".hardcoded,
                )
              : ProjectSuccessView(items: items),
        ),
      ),
    );
  }
}

class ProjectSuccessView extends ConsumerWidget {
  const ProjectSuccessView({super.key, required this.items});

  final List<Project> items;

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );

    if (confirm == true) {
      await ref.read(projectsControllerProvider.notifier).deleteProject(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(projectsControllerProvider);

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
                      onPressed: () =>
                          context.goNamed(AppRoute.projectEdit.name, extra: p),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: (action.isLoading || p.id == null)
                          ? null
                          : () => _confirmAndDelete(context, ref, p.id!),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
