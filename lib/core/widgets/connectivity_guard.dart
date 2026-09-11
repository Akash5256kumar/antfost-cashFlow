import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class ConnectivityGuard extends StatefulWidget {
  const ConnectivityGuard({super.key, required this.child});
  final Widget child;

  @override
  State<ConnectivityGuard> createState() => _ConnectivityGuardState();
}

class _ConnectivityGuardState extends State<ConnectivityGuard> {
  Timer? _probeTimer;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _probing = false;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((type) => type != ConnectivityResult.none)) {
        // Remove the blocking screen immediately on a restored interface;
        // the probe below still verifies real internet reachability.
        _setOffline(false);
        _probe();
      } else {
        _setOffline(true);
      }
    }, onError: (_) {});
    // Periodic fallback only; connectivity events trigger an immediate probe.
    // A longer interval avoids generating noisy health-check traffic.
    _probeTimer = Timer.periodic(const Duration(seconds: 10), (_) => _probe());
    _probe();
  }

  void _setOffline(bool value) {
    if (mounted && _offline != value) setState(() => _offline = value);
  }

  Future<void> _probe() async {
    if (_probing) return;
    _probing = true;
    try {
      // Do not probe the API host with HEAD: this endpoint/port can reject
      // HEAD (or be briefly unavailable) while the device still has working
      // internet, which caused a false blocking screen. Connectivity state
      // is the reliable signal for this global UI guard.
      final results = await Connectivity().checkConnectivity();
      _setOffline(results.every((type) => type == ConnectivityResult.none));
    } catch (_) {
      _setOffline(true);
    } finally {
      _probing = false;
    }
  }

  @override
  void dispose() {
    _probeTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_offline)
          Material(
            color: AppColors.background,
            child: SafeArea(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _probe,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * .25),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              size: 54,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'No internet connection',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please check your connection. The app will resume automatically when you are back online.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 22),
                          OutlinedButton.icon(
                            onPressed: _probe,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
