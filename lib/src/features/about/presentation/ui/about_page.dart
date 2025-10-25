import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/controller/about_controller.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/widgets/about_error_view.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/widgets/about_loading_view.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/widgets/about_success_view.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutActionState = ref.watch(aboutActionControllerProvider);
    final aboutState = ref.watch(aboutControllerProvider);

    Future<void> deleteItem() async {
      final items = aboutState.asData?.value ?? const <About>[];
      if (items.isEmpty || items.first.id == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Nothing to delete')));
        return;
      }
      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete about?'),
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
      if (!confirmed) return;
      await ref.read(aboutActionControllerProvider.notifier).deleteAbout(items.first.id!);
      if (!context.mounted) return;
      if (ref.read(aboutActionControllerProvider).hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Deleted')));
      }
    }

    void editItem() {
      final List<About> existing = aboutState.asData?.value ?? const [];
      context.goNamed(
        AppRoute.aboutEdit.name,
        extra: existing.isNotEmpty ? existing.first : null,
      );
    }

    return AppBar(
      title: const Text('About'),
      actions: [
        TextButton.icon(
          onPressed: editItem,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: aboutActionState.isLoading ? null : deleteItem,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
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
    final aboutState = ref.watch(aboutControllerProvider);
    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: aboutState.when(
          loading: () => AboutLoadingView(),
          error: (e, _) => AboutErrorView(message: e),
          data: (items) => AboutSuccessView(items: items),
        ),
      ),
    );
  }
}
