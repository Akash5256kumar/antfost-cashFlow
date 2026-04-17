import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _cardBg = Colors.white;
const Color _pageBg = Color(0xFFF5F5F8);
const Color _bannerBg = Color(0xFFEBE9FF);
const Color _noteBg = Color(0xFFEBE9FF);
const Color _progressTrack = Color(0xFFE5E7EB);
const Color _progressGreen = Color(0xFF22C55E);
const Color _progressBlue = Color(0xFF6366F1);
const Color _inProgressBg = Color(0xFFFEF3C7);
const Color _inProgressText = Color(0xFFD97706);
const Color _scheduledBg = Color(0xFFEDE9FD);
const Color _scheduledText = Color(0xFF7A6BFF);
const Color _orderIdColor = Color(0xFF7A6BFF);

// ── Status enum ───────────────────────────────────────────────────────────────
enum OrderStatus { inProgress, scheduled }

// ── Data model ────────────────────────────────────────────────────────────────
class OrderData {
  final String orderId;
  final OrderStatus status;
  final String grade;
  final String location;
  final String timeSlot;
  final String volume;
  final String date;
  final String amount;
  final int? delivered;
  final int? total;

  const OrderData({
    required this.orderId,
    required this.status,
    required this.grade,
    required this.location,
    required this.timeSlot,
    required this.volume,
    required this.date,
    required this.amount,
    this.delivered,
    this.total,
  });
}

// ── Static sample data ────────────────────────────────────────────────────────
const _orders = [
  OrderData(
    orderId: 'AF-2024-02-000001',
    status: OrderStatus.inProgress,
    grade: 'C25/30',
    location: 'Marina Tower - Ground Floor',
    timeSlot: '6 AM - 10 AM (±4 hrs)',
    volume: '50 m³ • 5 trips',
    date: '7 Feb, 10:06 AM',
    amount: 'AED 17,400',
    delivered: 20,
    total: 50,
  ),
  OrderData(
    orderId: 'AF-2024-02-000002',
    status: OrderStatus.scheduled,
    grade: 'C30/37',
    location: 'Palm Villa Site A',
    timeSlot: '6 AM - 12 PM (±6 hrs)',
    volume: '25 m³ • 3 trips',
    date: '6 Feb, 12:06 PM',
    amount: 'AED 9,450',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),

                    // ── Header ─────────────────────────────────────────────
                    const _HomeHeader(userName: 'Omar'),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Order Concrete banner ──────────────────────────────
                    const _OrderConcreteBanner(),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Active Order section ───────────────────────────────
                    _SectionHeader(
                      title: 'Active Order',
                      actionLabel: 'View Details',
                      onAction: () {},
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Order cards ────────────────────────────────────────
                    ..._orders.map(
                      (o) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _OrderCard(data: o),
                      ),
                    ),

                    // ── Note card ──────────────────────────────────────────
                    const _NoteCard(
                      text:
                          'Note: Orders above 100m³ require coordinator review and approval before scheduling.',
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home header ───────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  final String userName;
  const _HomeHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back,',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.fieldBorder, width: 1.3),
              color: AppColors.white,
            ),
            child: const Icon(
              Icons.more_horiz_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Order Concrete banner ─────────────────────────────────────────────────────
class _OrderConcreteBanner extends StatelessWidget {
  const _OrderConcreteBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Truck + text ───────────────────────────────────────────────
          Row(
            children: [
              Image.asset(
                AppAssets.mixtureMachine,
                height: 62,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Concrete',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Get instant pricing & fast delivery',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── CTA button ─────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.newCashOrder),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSpacing.buttonRadius,
                    ),
                  ),
                ),
                child: const Text(
                  '+ New Cash Order',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Order card ────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderData data;
  const _OrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final hasProgress = data.delivered != null && data.total != null;
    final progress = hasProgress ? data.delivered! / data.total! : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Order ID + status badge ──────────────────────────────────────
          Row(
            children: [
              Text(
                data.orderId,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _orderIdColor,
                ),
              ),
              const Spacer(),
              _StatusBadge(status: data.status),
            ],
          ),

          const SizedBox(height: 6),

          // ── Grade ────────────────────────────────────────────────────────
          Text(
            data.grade,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Info rows ────────────────────────────────────────────────────
          _InfoRow(icon: Icons.location_on_outlined, text: data.location),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.access_time_rounded, text: data.timeSlot),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.local_shipping_outlined, text: data.volume),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.fieldBorder, height: 1),
          const SizedBox(height: AppSpacing.md),

          // ── Date + Amount ─────────────────────────────────────────────────
          Row(
            children: [
              Text(
                data.date,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                data.amount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          // ── Progress section (in-progress orders only) ────────────────────
          if (hasProgress) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  'Delivered: ${data.delivered} m³',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Remaining: ${data.total! - data.delivered!} m³',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _GradientProgressBar(progress: progress),
          ],
        ],
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isInProgress = status == OrderStatus.inProgress;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isInProgress ? _inProgressBg : _scheduledBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isInProgress ? 'in Progress' : 'Scheduled',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isInProgress ? _inProgressText : _scheduledText,
        ),
      ),
    );
  }
}

// ── Gradient progress bar ─────────────────────────────────────────────────────
class _GradientProgressBar extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  const _GradientProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 7,
        child: Stack(
          children: [
            Container(color: _progressTrack),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_progressGreen, _progressBlue],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Note card ─────────────────────────────────────────────────────────────────
class _NoteCard extends StatelessWidget {
  final String text;
  const _NoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: _noteBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
