import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

const double _mobileBreakpoint = 600;
const double _contentMaxWidth = 1000;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.dashboard_customize_outlined, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Admin Panel',
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
            color: theme.colorScheme.outlineVariant.withAlpha((0.5 * 250).toInt()),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < _mobileBreakpoint;
                        final titleStyle = theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        );
                        final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Welcome to your Admin', style: titleStyle),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Manage your portfolio content quickly and comfortably on the web.',
                                          style: subtitleStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome to your Admin', style: titleStyle),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Manage your portfolio content quickly and comfortably on the web.',
                                    style: subtitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    int columns;
                    if (maxWidth < 520) {
                      columns = 1;
                    } else if (maxWidth < 900) {
                      columns = 2;
                    } else if (maxWidth < 1200) {
                      columns = 3;
                    } else {
                      columns = 4;
                    }
                    final isMobile = maxWidth < _mobileBreakpoint;
                    final aspect = isMobile ? 2.2 : 1.25;

                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: aspect,
                      children: [
                        _ActionCard(
                          icon: Icons.edit_note_outlined,
                          title: 'Intro',
                          subtitle: 'Edit landing intro text and links',
                          onTap: () => context.goNamed(AppRoute.intro.name),
                        ),
                        _ActionCard(
                          icon: Icons.person_outline,
                          title: 'About',
                          subtitle: 'Your story and background',
                          onTap: () => context.goNamed(AppRoute.about.name),
                        ),
                        _ActionCard(
                          icon: Icons.handyman_outlined,
                          title: 'Skills',
                          subtitle: 'Manage skill list & levels',
                          onTap: () => context.goNamed(AppRoute.skills.name),
                        ),
                        _ActionCard(
                          icon: Icons.work_outline,
                          title: 'Projects',
                          subtitle: 'Add and edit projects',
                          onTap: () => context.goNamed(AppRoute.projects.name),
                        ),
                        _ActionCard(
                          icon: Icons.link_outlined,
                          title: 'Social Links',
                          subtitle: 'Add GitHub, LinkedIn, etc.',
                          onTap: () => context.goNamed(AppRoute.social.name),
                        ),

                        _ActionCard(
                          icon: Icons.business_center_outlined,
                          title: 'Experience',
                          subtitle: 'Roles and timeline',
                          onTap: () => context.goNamed(AppRoute.experience.name),
                        ),
                        _ActionCard(
                          icon: Icons.school_outlined,
                          title: 'Education',
                          subtitle: 'Degrees and courses',
                          onTap: () => context.goNamed(AppRoute.education.name),
                        ),
                        _ActionCard(
                          icon: Icons.workspace_premium_outlined,
                          title: 'Certifications',
                          subtitle: 'Certificates & credentials',
                          onTap: () => context.goNamed(AppRoute.certifications.name),
                        ),
                        _ActionCard(
                          icon: Icons.contact_mail_outlined,
                          title: 'Contact',
                          subtitle: 'Email, phone, website',
                          onTap: () => context.goNamed(AppRoute.contact.name),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _hovering = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final interactive = widget.enabled && widget.onTap != null;
    final showLift = _hovering || _focused;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: showLift ? colorScheme.outlineVariant : Colors.transparent),
    );

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.6,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        mouseCursor: interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hovering = v),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          tween: Tween<double>(begin: 0.0, end: showLift ? 3.0 : 0.0),
          builder: (context, elevation, child) {
            return Card(
              elevation: elevation,
              shape: shape,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: interactive ? widget.onTap : null,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Semantics(
                    button: true,
                    enabled: widget.enabled,
                    label: '${widget.title}. ${widget.subtitle}',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _IconBadge(icon: widget.icon),
                            const Spacer(),
                            Icon(
                              Icons.arrow_outward,
                              size: 18.0,
                              color: colorScheme.outline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 22, color: colorScheme.onPrimaryContainer),
    );
  }
}
