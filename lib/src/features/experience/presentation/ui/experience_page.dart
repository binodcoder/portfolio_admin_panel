import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/experience/data/experience_repository.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/controller/experience_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

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
    void createNew() => context.goNamed(AppRoute.experienceEdit.name, extra: null);

    return AppBar(
      title: const Text('Experience'),
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
    final state = ref.watch(experienceListProvider);

    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: AsyncValueWidget(
          value: state,
          data: (items) => items.isEmpty
              ? EmptyState(
                  title: "No Experience yet".hardcoded,
                  subTitle: "Try adding some experience".hardcoded,
                )
              : ExperienceSuccessView(items: items),
        ),
      ),
    );
  }
}

class ExperienceSuccessView extends ConsumerWidget {
  const ExperienceSuccessView({super.key, required this.items});

  final List<Experience> items;

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return date.toIso8601String().split('T').first;
  }

  String _subtitleFor(Experience e) {
    final startText = _formatDate(e.start);
    final endText = e.current ? 'Present' : _formatDate(e.end);
    final dateRange = [startText, endText].where((text) => text.isNotEmpty).join(' - ');
    final location = e.location;
    if (location == null || location.isEmpty) {
      return dateRange;
    }
    if (dateRange.isEmpty) {
      return location;
    }
    return '$dateRange • $location';
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );

    if (confirm == true) {
      await ref.read(experienceControllerProvider.notifier).deleteExperience(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(experienceControllerProvider);

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
                subtitle: Text(_subtitleFor(e)),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.goNamed(AppRoute.experienceEdit.name, extra: e),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: (action.isLoading || e.id == null)
                          ? null
                          : () => _confirmAndDelete(context, ref, e.id!),
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
