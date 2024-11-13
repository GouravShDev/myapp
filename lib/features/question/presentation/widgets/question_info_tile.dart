import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestionInfoTile extends HookWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const QuestionInfoTile({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        /// Prevents to splash effect when clicking.
        splashColor: Colors.transparent,

        /// Prevents the mouse cursor to highlight the tile when hovering on web.
        hoverColor: Colors.transparent,

        /// Hides the highlight color when the tile is pressed.
        highlightColor: Colors.transparent,

        /// Makes the top and bottom dividers invisible when expanded.
        dividerColor: Colors.transparent,

        /// Make background transparent.
        expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        shape: Border(),
        tilePadding: EdgeInsets.zero,
        enableFeedback: false,
        onExpansionChanged: (expanded) {
          if (expanded) {
            // waiting to tile to expand then scroll to bottom
            Future.delayed(const Duration(milliseconds: 500), () {
              final scrollController =
                  InheritedDataProvider.of<ScrollController>(context);
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          }
        },
        expandedAlignment: Alignment.centerLeft,
        title: Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.outline,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: children,
      ),
    );
  }
}
