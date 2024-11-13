import 'package:flutter/material.dart';

class InheritedDataProvider<T> extends InheritedWidget {
  final T data;

  const InheritedDataProvider({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedDataProvider<T> oldWidget) {
    return oldWidget.data != data; // Only notify if data changes
  }

  static T of<T>(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<InheritedDataProvider<T>>();
    assert(widget != null,
        'No InheritedDataProvider found in context for type $T');
    return widget!.data;
  }
}
