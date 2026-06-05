import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:binodfolioadmin/src/common_widgets/responsive_center.dart';
import 'package:binodfolioadmin/src/constants/app_sizes.dart';
import 'package:binodfolioadmin/src/constants/breakpoints.dart';
import 'package:binodfolioadmin/src/features/home/widgets/action_card.dart';
import 'package:binodfolioadmin/src/features/home/widgets/main_header.dart';
import 'package:binodfolioadmin/src/features/home/widgets/sub_header.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/routing/app_router.dart';

class QuickAction {
  const QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final AppRoute route;
  final bool enabled;
}

const List<QuickAction> _quickActions = [
  QuickAction(
    icon: Icons.edit_note_outlined,
    title: 'Intro',
    subtitle: 'Edit landing intro text and links',
    route: AppRoute.intro,
  ),
  QuickAction(
    icon: Icons.person_outline,
    title: 'About',
    subtitle: 'Your story and background',
    route: AppRoute.about,
  ),
  QuickAction(
    icon: Icons.handyman_outlined,
    title: 'Skills',
    subtitle: 'Manage skill list & levels',
    route: AppRoute.skills,
  ),
  QuickAction(
    icon: Icons.work_outline,
    title: 'Projects',
    subtitle: 'Add and edit projects',
    route: AppRoute.projects,
  ),
  QuickAction(
    icon: Icons.link_outlined,
    title: 'Social Links',
    subtitle: 'Add GitHub, LinkedIn, etc.',
    route: AppRoute.social,
  ),
  QuickAction(
    icon: Icons.business_center_outlined,
    title: 'Experience',
    subtitle: 'Roles and timeline',
    route: AppRoute.experience,
  ),
  QuickAction(
    icon: Icons.school_outlined,
    title: 'Education',
    subtitle: 'Degrees and courses',
    route: AppRoute.education,
  ),
  QuickAction(
    icon: Icons.workspace_premium_outlined,
    title: 'Certifications',
    subtitle: 'Certificates & credentials',
    route: AppRoute.certifications,
  ),
  QuickAction(
    icon: Icons.contact_mail_outlined,
    title: 'Contact',
    subtitle: 'Email, phone, website',
    route: AppRoute.contact,
  ),
];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const _AppBar(), body: const _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();
  // Match the AppBar height (toolbar + bottom divider)
  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      toolbarHeight: 64,
      titleSpacing: 16,
      title: Row(
        children: [
          Icon(Icons.dashboard_customize_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Admin Panel'.hardcoded,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () => context.goNamed(AppRoute.account.name),
          style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
          icon: const Icon(Icons.person_outline),
          label: const Text('Account'),
        ),
        const SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant.withAlpha(125),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  double getAspect(double maxWidth) {
    final isMobile = maxWidth < Breakpoint.mobile;
    return isMobile ? 1 : 1.25;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const ResponsiveSliverCenter(
          maxContentWidth: Breakpoint.desktop,
          padding: EdgeInsets.symmetric(horizontal: Sizes.p24, vertical: Sizes.p32),
          child: MainHeader(),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Sizes.p24)),
        const ResponsiveSliverCenter(
          maxContentWidth: Breakpoint.desktop,
          padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
          child: SubHeader(title: 'Quick Actions'),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Sizes.p12)),
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final available = constraints.crossAxisExtent;
            const basePad = Sizes.p24;
            final inner = available - (basePad * 2);
            const target = Breakpoint.desktop;
            final extra = inner > target ? (inner - target) / 2 : 0.0;
            final hPad = basePad + extra;
            final gridWidth = available - (hPad * 2);
            final aspect = getAspect(gridWidth);

            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 280,
                  mainAxisSpacing: Sizes.p16,
                  crossAxisSpacing: Sizes.p16,
                  childAspectRatio: aspect,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final a = _quickActions[index];
                  return ActionCard(
                    icon: a.icon,
                    title: a.title,
                    subtitle: a.subtitle,
                    enabled: a.enabled,
                    onTap: () => context.goNamed(a.route.name),
                  );
                }, childCount: _quickActions.length),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Sizes.p32)),
      ],
    );
  }
}
