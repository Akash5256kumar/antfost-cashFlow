import 'package:flutter/material.dart';

/// Returns `true` when [context] belongs to the navigator's active route.
bool isCurrentRoute(BuildContext context) {
  return ModalRoute.of(context)?.isCurrent ?? true;
}

/// Replaces any visible or queued snack bar before showing [snackBar].
void showSingleSnackBar(BuildContext context, SnackBar snackBar) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.clearSnackBars();
  final controller = messenger.showSnackBar(
    SnackBar(
      content: snackBar.content,
      duration: const Duration(seconds: 2),
      behavior: snackBar.behavior,
      backgroundColor: snackBar.backgroundColor,
      action: snackBar.action,
    ),
  );
  // Explicit close is deliberate: on some Android accessibility settings a
  // snackbar containing an action can remain visible indefinitely.
  Future<void>.delayed(const Duration(seconds: 2), controller.close);
}

/// Standard transient feedback. A new message replaces the previous one so
/// validation/API errors never build up in the snackbar queue.
void showAppSnackBar(BuildContext context, String message) {
  showSingleSnackBar(
    context,
    SnackBar(content: Text(message)),
  );
}
