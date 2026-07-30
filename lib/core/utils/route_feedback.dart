import 'package:flutter/material.dart';

/// Returns `true` when [context] belongs to the navigator's active route.
bool isCurrentRoute(BuildContext context) {
  return ModalRoute.of(context)?.isCurrent ?? true;
}

/// Replaces any visible or queued snack bar before showing [snackBar].
void showSingleSnackBar(BuildContext context, SnackBar snackBar) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}
