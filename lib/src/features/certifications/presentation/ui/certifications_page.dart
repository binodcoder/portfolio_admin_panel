import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/constants/breakpoints.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/controller/certifications_controller.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/widgets/certification_error_view.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/widgets/certification_loading_view.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/widgets/certification_success_view.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class CertificationsPage extends StatelessWidget {
  const CertificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void createNew() => context.goNamed(AppRoute.certificationEdit.name);
    return Scaffold(
      appBar: _AppBar(onCreate: createNew),
      body: _Body(onCreate: createNew),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Certifications'),
      actions: [
        TextButton.icon(
          onPressed: onCreate,
          icon: const Icon(Icons.add_outlined),
          label: const Text('New'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.onCreate});

  final VoidCallback onCreate;

  void refresh(WidgetRef ref) {
    ref.invalidate(certificationsControllerProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(certificationsControllerProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoint.desktop),
        child: state.when(
          loading: () => const CertificationLoadingView(),
          error: (e, _) =>
              CertificationErrorView(message: e, onRetry: () => refresh(ref)),
          data: (items) => CertificationSuccessView(items: items, onCreate: onCreate),
        ),
      ),
    );
  }
}
