import 'package:flutter/material.dart';
import 'package:binodfolioadmin/src/features/home/widgets/icon_badge.dart';

class ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _hovering = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final interactive = widget.enabled && widget.onTap != null;
    final showLift = _hovering || _focused;
    final borderRadius = BorderRadius.circular(14);

    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
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
                // borderRadius: borderRadius,
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
                            IconBadge(icon: widget.icon),
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
