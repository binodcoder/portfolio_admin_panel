import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

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
    void createNew() => context.goNamed(AppRoute.educationEdit.name, extra: null);

    return AppBar(
      title: const Text('Education'),
      actions: [
        TextButton.icon(
          onPressed: createNew,
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
    final state = ref.watch(educationControllerProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: state.when(
          loading: () => EducationLoadingView(),
          error: (e, _) => EducationErrorView(error: e),
          data: (items) => EducationSuccessView(items: items),
        ),
      ),
    );
  }
}

class EducationLoadingView extends StatelessWidget {
  const EducationLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
    );
  }
}

class EducationErrorView extends StatelessWidget {
  const EducationErrorView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error: $error'));
  }
}

class EducationSuccessView extends ConsumerWidget {
  const EducationSuccessView({super.key, required this.items});

  final List<Education> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(educationActionControllerProvider);

    Future<void> deleteItem(Education e) async {
      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete education?'),
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
      await ref.read(educationActionControllerProvider.notifier).deleteEducation(e.id!);
    }

    void editItem(Education e) => context.goNamed(AppRoute.educationEdit.name, extra: e);
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
                const Expanded(child: Text('No education added yet')),
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
                title: Text('${e.degree ?? ''} ${e.field != null ? '• ${e.field}' : ''}'),
                subtitle: Text(
                  '${e.institution}${e.location != null ? ' • ${e.location}' : ''}\n${e.start ?? ''} - ${e.end ?? ''}',
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
  }
}
