import 'dart:async';
import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import 'live_tracking_screen.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({
    super.key,
    this.orderId = 'AF-2026-02-000123',
    this.scheduledDate = 'Wednesday, 25 June 2026',
    this.scheduledShift = 'Morning Shift (6 AM – 10 AM)',
    this.locationTitle = 'Marina Tower - Site A',
    this.locationAddress = 'Al Sufouh Road, Dubai Marina, Dubai',
    this.driverName = 'Abdul Rahman',
    this.truckId = 'TR-4022',
  });

  final String orderId;
  final String scheduledDate;
  final String scheduledShift;
  final String locationTitle;
  final String locationAddress;
  final String driverName;
  final String truckId;

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  // Countdown timer from 2h 45m 12s
  // For demo: short 10 second timer so you can see the transition.
  // In prod, use the real remaining seconds from backend.
  int _remainingSeconds = 10; // change to (2 * 3600) + (45 * 60) + 12 for real
  bool _timerDone = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _timerDone = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer() {
    final hours = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes =
        ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                context.scaled(8),
                context.scaledV(8),
                context.scaled(16),
                context.scaledV(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: context.scaled(24),
                      color: const Color(0xFF111827),
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 22,
                  ),
                  SizedBox(width: context.scaled(4)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: context.scaled(19),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        widget.orderId,
                        style: TextStyle(
                          fontSize: context.scaled(12),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.orderChat),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    tooltip: 'Dispatch Chat',
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(16),
                  vertical: context.scaledV(16),
                ),
                child: Column(
                  children: [
                    // 1. Order ID Card with CONFIRMED badge
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.scaled(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                        border: Border.all(color: const Color(0xFFF0F0F4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ID',
                                style: TextStyle(
                                  fontSize: context.scaled(12),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: context.scaledV(4)),
                              Text(
                                widget.orderId,
                                style: TextStyle(
                                  fontSize: context.scaled(16),
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaled(12),
                              vertical: context.scaledV(5),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(
                                context.scaled(12),
                              ),
                            ),
                            child: Text(
                              'SCHEDULED',
                              style: TextStyle(
                                fontSize: context.scaled(11.5),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF16A34A),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(14)),

                    // 2. Scheduled Delivery Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.scaled(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                        border: Border.all(color: const Color(0xFFF0F0F4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scheduled Delivery',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: context.scaledV(14)),

                          // Date & Shift
                          Row(
                            children: [
                              Container(
                                width: context.scaled(44),
                                height: context.scaled(44),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(
                                    context.scaled(12),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  size: context.scaled(20),
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: context.scaled(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.scheduledDate,
                                      style: TextStyle(
                                        fontSize: context.scaled(14.5),
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                    SizedBox(height: context.scaledV(2)),
                                    Text(
                                      widget.scheduledShift,
                                      style: TextStyle(
                                        fontSize: context.scaled(13),
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.scaledV(14)),

                          // Location
                          Row(
                            children: [
                              Container(
                                width: context.scaled(44),
                                height: context.scaled(44),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(
                                    context.scaled(12),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: context.scaled(22),
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: context.scaled(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.locationTitle,
                                      style: TextStyle(
                                        fontSize: context.scaled(14.5),
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                    SizedBox(height: context.scaledV(2)),
                                    Text(
                                      widget.locationAddress,
                                      style: TextStyle(
                                        fontSize: context.scaled(13),
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(14)),

                    // 3. Assigned Logistics Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.scaled(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                        border: Border.all(color: const Color(0xFFF0F0F4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned Logistics',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: context.scaledV(14)),
                          Row(
                            children: [
                              Container(
                                width: context.scaled(44),
                                height: context.scaled(44),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(
                                    context.scaled(12),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: context.scaled(22),
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: context.scaled(12)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.driverName,
                                    style: TextStyle(
                                      fontSize: context.scaled(15),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(2)),
                                  Text(
                                    'Truck ID: ${widget.truckId}',
                                    style: TextStyle(
                                      fontSize: context.scaled(13),
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(14)),

                    // 4. Delivery Starting In Countdown Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(20),
                        vertical: context.scaledV(20),
                      ),
                      decoration: BoxDecoration(
                        color: _timerDone
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _timerDone ? 'DELIVERY IS STARTING NOW' : 'DELIVERY STARTING IN',
                            style: TextStyle(
                              fontSize: context.scaled(12),
                              fontWeight: FontWeight.w700,
                              color: _timerDone
                                  ? const Color(0xFF16A34A)
                                  : AppColors.primary,
                              letterSpacing: 0.6,
                            ),
                          ),
                          SizedBox(height: context.scaledV(8)),
                          Text(
                            _timerDone ? '00:00:00' : _formatTimer(),
                            style: TextStyle(
                              fontSize: context.scaled(36),
                              fontWeight: FontWeight.w800,
                              color: _timerDone
                                  ? const Color(0xFF16A34A)
                                  : AppColors.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: context.scaledV(6)),
                          Text(
                            _timerDone
                                ? 'Tap "Track Order" to follow your delivery live'
                                : 'Estimated start: 06:00 AM',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w500,
                              color: _timerDone
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(24)),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Buttons ─────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                context.scaled(18),
                context.scaledV(10),
                context.scaled(18),
                context.scaledV(18),
              ),
              color: Colors.white,
              child: Column(
                children: [
                  // Track Order Button
                  SizedBox(
                    width: double.infinity,
                    height: context.scaled(52),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: _timerDone
                            ? const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF16A34A),
                                  Color(0xFF22C55E),
                                ],
                              )
                            : const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.primaryGradientStart,
                                  AppColors.primaryGradientEnd,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(
                          context.scaled(14),
                        ),
                      ),
                      child: TextButton(
                        onPressed: _timerDone
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LiveTrackingScreen(
                                      orderId: widget.orderId,
                                      driverName: widget.driverName,
                                      truckId: widget.truckId,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.scaled(14),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _timerDone ? 'Track Order Live' : 'Track Order',
                              style: TextStyle(
                                fontSize: context.scaled(16),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (_timerDone) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.gps_fixed_rounded, size: 16, color: Colors.white),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(10)),

                  // Contact Support Button
                  SizedBox(
                    width: double.infinity,
                    height: context.scaled(52),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.orderChat);
                      },
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      label: Text(
                        'Chat with Dispatch Support',
                        style: TextStyle(
                          fontSize: context.scaled(15.5),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.scaled(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
