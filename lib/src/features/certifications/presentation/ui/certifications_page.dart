import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/async_value_widget.dart';
import 'package:binodfolioadmin/src/common_widgets/empty_state.dart';
import 'package:binodfolioadmin/src/constants/breakpoints.dart';
import 'package:binodfolioadmin/src/features/certifications/data/certifications_repository.dart';
import 'package:binodfolioadmin/src/features/certifications/presentation/widgets/certification_success_view.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/routing/app_router.dart';

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
      title: Text('Certifications'.hardcoded),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(certificationListProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoint.desktop),
        child: AsyncValueWidget(
          value: state,
          data: (items) => items.isEmpty
              ? EmptyState(
                  title: "No certifications yet".hardcoded,
                  subTitle: "Trying adding".hardcoded,
                )
              : CertificationSuccessView(items: items),
        ),
      ),
    );
  }
}
