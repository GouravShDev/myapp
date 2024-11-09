import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppPaginationList extends StatelessWidget {
  const AppPaginationList({
    required this.itemBuilder,
    required this.itemCount,
    required this.moreAvailable,
    required this.loadMoreData,
    this.loadingWidget,
    super.key,
  });
  final VoidCallback loadMoreData;
  final bool moreAvailable;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter.toInt() == 0) {
          // User has reached the end of the list
          // Load more data or trigger pagination in flutter
          loadMoreData();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: itemCount + 1, // Add 1 for loading indicator
        itemBuilder: (context, index) {
          if (index < itemCount) {
            return itemBuilder(context, index);
          } else {
            if (!moreAvailable) return Container();
            loadMoreData(); // fetch more data if reached the end of the list

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: loadingWidget ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
            );
          }
        },
      ),
    );
  }
}