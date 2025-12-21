import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/education/data/education_repository.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/controller/education_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
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
    return AppBar(
      title: const Text('Education'),
      actions: [
        TextButton.icon(
          onPressed: () => context.goNamed(AppRoute.educationEdit.name, extra: null),
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
    final state = ref.watch(educationListProvider);

    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: AsyncValueWidget(
          value: state,
          data: (items) => items.isEmpty
              ? EmptyState(
                  title: "No Education added yet".hardcoded,
                  subTitle: "Try adding education".hardcoded,
                )
              : EducationSuccessView(items: items),
        ),
      ),
    );
  }
}

class EducationSuccessView extends ConsumerWidget {
  const EducationSuccessView({super.key, required this.items});

  final List<Education> items;

  Future<void> _confirmAndDeleteItem(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirm = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );

    if (confirm == true) {
      await ref.read(educationControllerProvider.notifier).deleteEducation(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(educationControllerProvider);

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
                      onPressed: () =>
                          context.goNamed(AppRoute.educationEdit.name, extra: e),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: (action.isLoading || e.id == null)
                          ? null
                          : () => _confirmAndDeleteItem(context, ref, e.id!),
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
