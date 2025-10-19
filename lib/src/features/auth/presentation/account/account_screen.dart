import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/alert_dialogs.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/auth/data/auth_repository.dart';
import 'package:portfolio_admin_panel/src/features/auth/domain/app_user.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/account/account_screen_controller.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/utils/async_value_ui.dart';
import 'package:flutter/services.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(accountScreenControllerProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.person_outline, color: colors.primary),
            const SizedBox(width: 8),
            Text('Account'.hardcoded,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            if (state.isLoading) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            ]
          ],
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Are you sure?'.hardcoded,
                      cancelActionText: 'Cancel'.hardcoded,
                      defaultActionText: 'Logout'.hardcoded,
                    );
                    if (logout == true) {
                      ref.read(accountScreenControllerProvider.notifier).signOut();
                    }
                  },
            style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
            icon: const Icon(Icons.logout_outlined),
            label: Text('Logout'.hardcoded),
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      body: const Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p16),
          child: AccountScreenContents(),
        ),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class AccountScreenContents extends ConsumerWidget {
  const AccountScreenContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.primaryContainer,
                    foregroundColor: colors.onPrimaryContainer,
                    child: const Icon(Icons.person_outline),
                  ),
                  gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email ?? '-', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.uid,
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy UID'.hardcoded,
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: user.uid));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('UID copied'.hardcoded)),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy_outlined),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  EmailVerificationWidget(user: user),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailVerificationWidget extends ConsumerWidget {
  const EmailVerificationWidget({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);
    if (user.emailVerified == false) {
      return OutlinedButton.icon(
        onPressed: state.isLoading
            ? null
            : () async {
                final success = await ref
                    .read(accountScreenControllerProvider.notifier)
                    .sendEmailVerification(user);
                if (success && context.mounted) {
                  showAlertDialog(
                    context: context,
                    title: 'Sent - now check your email'.hardcoded,
                  );
                }
              },
        icon: const Icon(Icons.mark_email_read_outlined),
        label: Text('Verify email'.hardcoded),
      );
    } else {
      final theme = Theme.of(context);
      final colors = theme.colorScheme;
      return Chip(
        avatar: Icon(Icons.check_circle, color: colors.primary),
        label: Text('Verified'.hardcoded),
        backgroundColor: colors.primaryContainer,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.onPrimaryContainer),
      );
    }
  }
}
