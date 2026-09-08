import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';

/// Lifecycle stages for an order delivery
enum OrderLifecycleStage {
  scheduled,
  loadingStarted,
}

/// Unified Single-Screen Order Details & Tracking with reactive lifecycle states.
/// Handles both the "Delivery Scheduled" view and the "Loading Started" production view.
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
    this.quantity = 120,
    this.mixCode = 'C30/37',
    this.proposedDate = 'Tuesday · 12 August',
    this.proposedTime = '08:30',
    this.supplyWindow = '08:30–11:00',
    this.deliveryInterval = '12 min interval',
    this.location = 'Main Villa Entrance',
    this.resources,
    this.initialStage = OrderLifecycleStage.scheduled,
    this.isDraft = false,
  });

  final String orderId;
  final String projectName;
  final int quantity;
  final String mixCode;
  final String proposedDate;
  final String proposedTime;
  final String supplyWindow;
  final String deliveryInterval;
  final String location;
  final String? resources;
  final OrderLifecycleStage initialStage;
  final bool isDraft;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderLifecycleStage _currentStage;

  @override
  void initState() {
    super.initState();
    _currentStage = widget.initialStage;
  }

  void _handleBack() {
    if (_currentStage == OrderLifecycleStage.loadingStarted &&
        widget.initialStage == OrderLifecycleStage.scheduled) {
      setState(() => _currentStage = OrderLifecycleStage.scheduled);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBrandHeader(
        showBack: true,
        onBack: _handleBack,
        showChat: true,
        onChatTap: () => Navigator.of(context).pushNamed(AppRoutes.orderChat),
        onBellTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _currentStage == OrderLifecycleStage.scheduled
            ? _buildScheduledView(context)
            : _buildLoadingStartedView(context),
      ),
    );
  }

  // ==========================================
  // STATE 1: DELIVERY SCHEDULED VIEW
  // ==========================================
  Widget _buildScheduledView(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('scheduled_view'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            'Delivery Scheduled',
            style: AppTextStyles.authScreenTitle(context).copyWith(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF6366F1)),
                  SizedBox(width: 6),
                  Text(
                    'Scheduled',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Hero Image (Villa + Concrete Pump Truck)
          AppIllustrationImage(
            asset: AppAssets.artVillaPumpHero,
            height: 180,
            borderRadius: 16,
          ),
          const SizedBox(height: 14),

          // Date & Time Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x081E1946),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.proposedDate,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.proposedTime,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Order Specs Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildSpecRow(
                  icon: Icons.layers_rounded,
                  value: '${widget.quantity} m³ · ${widget.mixCode}',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildSpecRow(
                  icon: Icons.access_time_rounded,
                  value: widget.deliveryInterval,
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildSpecRow(
                  icon: Icons.engineering_rounded,
                  value: widget.resources ?? 'Pump + Technician',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildSpecRow(
                  icon: Icons.location_on_outlined,
                  value: widget.location,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Supply Window Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.access_time_rounded,
                    size: 22,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Supply Window',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.supplyWindow,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Updates automatically if the delivery plan changes',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Notification Info Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.notifications_none_rounded, size: 16, color: Color(0xFF6366F1)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "We'll notify you when loading is completed.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Primary Button: View Order Details / Plant Loading
          PrimaryButton(
            arrow: true,
            label: 'View Order Details',
            onPressed: () {
              setState(() => _currentStage = OrderLifecycleStage.loadingStarted);
            },
          ),
          const SizedBox(height: 10),

          // Secondary Button: Add to Calendar
          PrimaryButton(
            variant: PrimaryButtonVariant.outline,
            icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF4F46E5)),
            label: 'Add to Calendar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delivery schedule added to calendar'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 24),
        ],
      ),
    );
  }

  // ==========================================
  // STATE 2: LOADING STARTED & PRODUCTION VIEW
  // ==========================================
  Widget _buildLoadingStartedView(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('loading_started_view'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            'Order Details',
            style: AppTextStyles.authScreenTitle(context).copyWith(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),

          // Status Badge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF4F46E5)),
                  SizedBox(width: 6),
                  Text(
                    'Loading started',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Order Reference Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Order ${widget.orderId} · ${widget.projectName} · ${widget.mixCode}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Hero Artwork: Plant Depot & Circular Meter (artLoadingGauge)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppAssets.artLoadingGauge,
              height: 210,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),

          // 3-Step Live Production Timeline
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildTimelineItem(
                  title: 'Loading started',
                  subtitle: 'In progress',
                  isCompleted: true,
                  isCurrent: true,
                  isLast: false,
                ),
                _buildTimelineItem(
                  title: 'Loading completed',
                  subtitle: "We'll notify you when loading is complete",
                  isCompleted: false,
                  isCurrent: false,
                  isLast: false,
                ),
                _buildTimelineItem(
                  title: 'On the way',
                  subtitle: 'Tracking begins after departure',
                  isCompleted: false,
                  isCurrent: false,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dispatch Info Notice Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    size: 19,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your first delivery resource is being loaded.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Live tracking appears after departure and initial movement toward your site.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Assigned Resources Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.precision_manufacturing_rounded,
                    size: 19,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  widget.resources ??
                      (widget.quantity > 0
                          ? 'Pump + ${(widget.quantity / 15).ceil().clamp(1, 10)} Trucks'
                          : 'Pump + 8 Trucks'),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          PrimaryButton(
            arrow: true,
            label: 'View Live Tracking',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.liveTracking),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            variant: PrimaryButtonVariant.outline,
            label: 'View Schedule Info',
            onPressed: () {
              setState(() => _currentStage = OrderLifecycleStage.scheduled);
            },
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (r) => false,
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 20),
        ],
      ),
    );
  }

  // Helper: Specs Row for Scheduled Card
  Widget _buildSpecRow({required IconData icon, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Timeline Item
  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF4F46E5) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isCompleted ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    color: isCurrent
                        ? const Color(0xFF4F46E5)
                        : (isCompleted ? const Color(0xFF0F172A) : const Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                if (!isLast) const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
