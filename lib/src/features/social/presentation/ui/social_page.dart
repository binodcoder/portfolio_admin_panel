import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/features/social/data/social_repository.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_controller.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/widgets/social_card.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';
import 'package:portfolio_admin_panel/src/utils/async_value_ui.dart';

class SocialPage extends ConsumerWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      socialControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
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
      title: Text('Social Links'.hardcoded),
      actions: [
        TextButton.icon(
          onPressed: () => context.goNamed(AppRoute.socialEdit.name, extra: null),
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
    final socialLinkList = ref.watch(socialLinkListProvider);

    return ResponsiveCenter(
      child: AsyncValueWidget(
        value: socialLinkList,
        data: (items) => items.isEmpty
            ? EmptyState(
                title: "No Social items".hardcoded,
                subTitle: "Try adding some".hardcoded,
              )
            : SocialSuccessView(items: items),
      ),
    );
  }
}

class SocialSuccessView extends ConsumerWidget {
  const SocialSuccessView({super.key, required this.items});

  final List<SocialLink> items;

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );

    if (confirm == true) {
      await ref.read(socialControllerProvider.notifier).deleteSocial(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(socialControllerProvider.select((s) => s.isLoading));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final canDelete = !isLoading && item.id != null;

        return SocialCard(
          socialLink: item,
          onDelete: canDelete ? () => _confirmAndDelete(context, ref, item.id!) : null,
        );
      },
    );
  }
}
