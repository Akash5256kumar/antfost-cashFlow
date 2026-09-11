import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class DebugUpgradePrompt extends StatefulWidget {
  const DebugUpgradePrompt({super.key, required this.child, this.navigatorKey});
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<DebugUpgradePrompt> createState() => _DebugUpgradePromptState();
}

class _DebugUpgradePromptState extends State<DebugUpgradePrompt> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Future<void>.delayed(const Duration(seconds: 4), () {
          if (!mounted) return;
          final navigatorContext = widget.navigatorKey?.currentContext;
          if (navigatorContext == null) return;
          showDialog<void>(
            context: navigatorContext,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Update available'),
              content: const Text(
                'Debug update prompt — this confirms the app upgrader test flow.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Later'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class DelayedUpgradeAlert extends StatefulWidget {
  const DelayedUpgradeAlert({
    super.key,
    required this.child,
    required this.navigatorKey,
  });
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  State<DelayedUpgradeAlert> createState() => _DelayedUpgradeAlertState();
}

class _DelayedUpgradeAlertState extends State<DelayedUpgradeAlert> {
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) => !_ready
      ? widget.child
      : UpgradeAlert(
          navigatorKey: widget.navigatorKey,
          upgrader: Upgrader(
            // debugDisplayAlways: kDebugMode,
            // debugDisplayOnce: false,
            // debugLogging: kDebugMode,
            
          ),
          child: widget.child,
        );
}
