import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_action_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final items = ref.read(introControllerProvider).asData?.value ?? const <Intro>[];
    if (items.isEmpty || items.first.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing to delete')));
      return;
    }

    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete intro?'),
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

    if (!confirm) return;

    await ref.read(introActionControllerProvider.notifier).deleteIntro(items.first.id!);
    final action = ref.read(introActionControllerProvider);
    if (action.hasError) {
      final message = 'Failed to delete: ${action.error}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Intro deleted')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introState = ref.watch(introControllerProvider);
    final deleteState = ref.watch(introActionControllerProvider);

    void goToEdit() {
      final List<Intro> existing = introState.asData?.value ?? const [];
      context.goNamed(
        AppRoute.introEdit.name,
        extra: existing.isNotEmpty ? existing.first : null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intro'),
        actions: [
          TextButton.icon(
            onPressed: goToEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: deleteState.isLoading ? null : () => _delete(context, ref),
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
          child: introState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: _ErrorCard(message: 'Failed to load intro: $error'),
            ),
            data: (items) {
              final item = items.isNotEmpty ? items.first : null;
              if (item == null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: _EmptyState(onCreate: goToEdit),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  clipBehavior: Clip.antiAlias,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 40, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No introduction yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add a short introduction to show on your portfolio.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_outlined),
              label: const Text('Add Intro'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 40, color: colorScheme.error),
            const SizedBox(width: 16),
            Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
