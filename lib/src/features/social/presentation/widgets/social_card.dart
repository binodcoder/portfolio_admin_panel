import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/routing/app_router.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({super.key, required this.socialLink, required this.onDelete});

  final SocialLink socialLink;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(socialLink.platform),
        subtitle: Text(socialLink.url),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              onPressed: () =>
                  context.goNamed(AppRoute.socialEdit.name, extra: socialLink),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}
