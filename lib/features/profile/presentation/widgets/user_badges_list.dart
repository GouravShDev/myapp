import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/presentation/widgets/badge_carousel.dart';
import 'package:flutter/material.dart';

class UserBadgesList extends StatelessWidget {
  const UserBadgesList({super.key, this.badges});
  final List<LeetCodeBadge>? badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    if (badges == null || badges!.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Badges : ",
              style: textTheme.titleMedium?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              badges!.length.toString(),
              style: textTheme.titleMedium,
            ),
          ],
        ),
        BadgeCarousel(
          badges: badges!,
        ),
      ],
    );
  }
}
