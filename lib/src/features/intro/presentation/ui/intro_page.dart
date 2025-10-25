import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/error_card.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/widgets/intro_card.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(65);

  Intro? _currentIntro(WidgetRef ref) {
    final data = ref.read(introControllerProvider).asData?.value;
    if (data == null || data.isEmpty) return null;
    return data.first;
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed =
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
    return confirmed;
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deleteCurrent(BuildContext context, WidgetRef ref) async {
    final current = _currentIntro(ref);
    if (current?.id == null) return;

    final confirm = await _confirmDelete(context);
    if (!confirm) return;

    await ref.read(introActionControllerProvider.notifier).deleteIntro(current!.id!);
    final action = ref.read(introActionControllerProvider);
    if (!context.mounted) return;
    if (action.hasError) {
      _showSnack(context, 'Failed to delete: ${action.error}');
    } else {
      _showSnack(context, 'Intro deleted');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(introActionControllerProvider);
    final introState = ref.watch(introControllerProvider);

    final currentIntro = (introState.asData?.value.isNotEmpty ?? false)
        ? introState.asData!.value.first
        : null;

    void goToEdit() {
      context.goNamed(AppRoute.introEdit.name, extra: currentIntro);
    }

    return AppBar(
      title: const Text('Intro'),
      actions: [
        TextButton.icon(
          onPressed: goToEdit,
          icon: Icon(
            actionState.isLoading || currentIntro?.id == null
                ? Icons.add_outlined
                : Icons.edit_outlined,
          ),
          label: Text(actionState.isLoading || currentIntro?.id == null ? 'Add' : 'Edit'),
        ),
        const SizedBox(width: 4),
        TextButton.icon(
          onPressed: actionState.isLoading || currentIntro?.id == null
              ? null
              : () => _deleteCurrent(context, ref),
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

  static const double _maxWidth = 900;
  static const double _pagePadding = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introState = ref.watch(introControllerProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: introState.when(
          loading: () => const IntroLoadingView(),
          error: (error, _) => IntroErrorView(error: error, pagePadding: _pagePadding),
          data: (items) => IntroSuccessView(items: items, pagePadding: _pagePadding),
        ),
      ),
    );
  }
}

class IntroLoadingView extends StatelessWidget {
  const IntroLoadingView({super.key});

  static const double _loadingPadding = 32;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_loadingPadding),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class IntroErrorView extends StatelessWidget {
  const IntroErrorView({super.key, required this.error, required this.pagePadding});

  final Object error;
  final double pagePadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(pagePadding),
      child: ErrorCard(message: 'Failed to load intro: $error'),
    );
  }
}

class IntroSuccessView extends StatelessWidget {
  const IntroSuccessView({super.key, required this.items, required this.pagePadding});

  final List<Intro> items;
  final double pagePadding;

  @override
  Widget build(BuildContext context) {
    final item = items.isNotEmpty ? items.first : null;
    if (item == null) {
      return Padding(padding: EdgeInsets.all(pagePadding), child: EmptyState());
    }
    return Padding(
      padding: EdgeInsets.all(pagePadding),
      child: IntroCard(text: item.value, padding: EdgeInsets.all(pagePadding)),
    );
  }
}
