import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
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
        child: AsyncValueWidget(
          value: state,
          data: (items) => items.isEmpty
              ? EmptyState(
                  title: "No Social items".hardcoded,
                  subTitle: "Try adding some".hardcoded,
                )
              : SocialSuccessView(items: items),
        ),
      ),
    );
  }
}

class SocialSuccessView extends ConsumerWidget {
  const SocialSuccessView({super.key, required this.items});

  final List<SocialLink> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(socialControllerProvider);

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
      await ref.read(socialControllerProvider.notifier).deleteSocial(s.id!);
    }

    void editItem(SocialLink s) => context.goNamed(AppRoute.socialEdit.name, extra: s);

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
