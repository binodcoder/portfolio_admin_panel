import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/common_widgets/async_value_widget.dart';
import 'package:portfolio_admin_panel/src/common_widgets/empty_state.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_center.dart';
import 'package:portfolio_admin_panel/src/common_widgets/text_area_card.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/about/data/about_repository.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class AboutBody extends ConsumerWidget {
  const AboutBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutValue = ref.watch(aboutListProvider);
    return SingleChildScrollView(
      child: ResponsiveCenter(
        child: AsyncValueWidget<List<About?>>(
          value: aboutValue,
          data: (items) {
            final item = items.isEmpty ? null : items.first;
            if (item == null) {
              return EmptyState(
                title: 'No content yet'.hardcoded,
                subTitle: 'Add a short about to show on your portfolio.'.hardcoded,
              );
            }
            return AboutSuccessView(item: item);
          },
        ),
      ),
    );
  }
}

class AboutSuccessView extends StatelessWidget {
  const AboutSuccessView({super.key, required this.item});

  final About item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: TextAreaCard(text: item.value, padding: const EdgeInsets.all(Sizes.p4)),
    );
  }
}
