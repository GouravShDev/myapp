import 'package:codersgym/core/routes/app_router.dart';
import 'package:codersgym/features/common/dialog/leetcode_session_expired_dialog.dart';
import 'package:flutter/material.dart';

class AppErrorNotifier {
  final AppRouter appRouter;

  AppErrorNotifier(this.appRouter);

  BuildContext? get _context => appRouter.navigatorKey.currentContext;

  AppErrorNotification? _currentNotification;

  /// Handle errors based on their type and display method
  Future<void> notify(
    AppErrorNotification notification,
  ) async {
    final context = _context;
    if (context == null) return;

    // Display error based on the ErrorDisplay type
    switch (notification) {
      case AppAlertDialogNotification():
        _handleAlertNotification(context, notification);
      case AppToastNotification():
        _handleToastNotification(context, notification);
      case AppSnackbarNotification():
        _handleSnackbarNotification(context, notification);
    }

    _currentNotification = notification;
  }

  void _handleAlertNotification(
      BuildContext context, AppAlertDialogNotification notification) {
    switch (notification) {
      case LeetcodeSessionExpireDialogNotification():
        LeetcodeSessionExpiredDialog.show(context);
    }
  }

  void _handleToastNotification(
      BuildContext context, AppToastNotification notification) {
    switch (notification) {
      case GenericToastNotification():
      // TODO : handle
    }
  }

  void _handleSnackbarNotification(
      BuildContext context, AppSnackbarNotification notification) {
    final message = notification.message;
    final currentNotification = _currentNotification;
    // Prevent duplicate snackbar
    if (currentNotification is AppSnackbarNotification &&
        currentNotification.message == notification.message) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        )
        .closed
        .then(
          (value) => _currentNotification = null,
        );
  }
}

/// Sealed class representing different types of error displays
sealed class AppErrorNotification {
  const AppErrorNotification();
}

sealed class AppAlertDialogNotification extends AppErrorNotification {
  const AppAlertDialogNotification();
}

sealed class AppToastNotification extends AppErrorNotification {
  final String message;
  const AppToastNotification({
    required this.message,
  });
}

class GenericToastNotification extends AppToastNotification {
  const GenericToastNotification({
    required super.message,
  });
}

sealed class AppSnackbarNotification extends AppErrorNotification {
  final String message;

  const AppSnackbarNotification({
    required this.message,
  });
}

class GenericSnackbarNotification extends AppSnackbarNotification {
  const GenericSnackbarNotification({
    required super.message,
  });
}

// Special cases

class NoInternetSnackbarNotification extends AppSnackbarNotification {
  NoInternetSnackbarNotification() : super(message: "No Internet Available");
}

class LeetcodeSessionExpireDialogNotification
    extends AppAlertDialogNotification {}
