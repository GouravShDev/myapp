import 'package:flutter/material.dart';

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({
    super.key,
    required this.title,
    required this.data,
  });
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          title,
          style: textTheme.labelSmall,
        ),
        Text(
          data,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
