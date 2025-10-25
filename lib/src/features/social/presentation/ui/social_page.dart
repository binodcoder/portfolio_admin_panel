import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_controller.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class SocialPage extends ConsumerWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    void createNew() => context.goNamed(AppRoute.socialEdit.name, extra: null);
    return AppBar(
      title: const Text('Social Links'),
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
    final state = ref.watch(socialControllerProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: state.when(
          loading: () => SocialLoadingView(),
          error: (e, _) => SocialErrorView(error: e),
          data: (items) => SocialSuccessView(items: items),
        ),
      ),
    );
  }
}

class SocialLoadingView extends StatelessWidget {
  const SocialLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
    );
  }
}

class SocialErrorView extends StatelessWidget {
  const SocialErrorView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error: $error'));
  }
}

class SocialSuccessView extends ConsumerWidget {
  const SocialSuccessView({super.key, required this.items});

  final List<SocialLink> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(socialActionControllerProvider);

    Future<void> deleteItem(SocialLink s) async {
      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete link?'),
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
      await ref.read(socialActionControllerProvider.notifier).deleteSocial(s.id!);
    }

    void editItem(SocialLink s) => context.goNamed(AppRoute.socialEdit.name, extra: s);
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
                const Expanded(child: Text('No links yet')),
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
          for (final s in items)
            Card(
              child: ListTile(
                title: Text(s.platform),
                subtitle: Text(s.url),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      onPressed: () => editItem(s),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: action.isLoading || s.id == null
                          ? null
                          : () => deleteItem(s),
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
