import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'domain/entities/home_data.dart';
import 'presentation/bloc/home_bloc.dart';
import 'presentation/bloc/home_event.dart';
import 'presentation/bloc/home_state.dart';

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

// ── Screen ────────────────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      bottomNavigationBar: const AppTabBottomNavBar(currentTab: AppTab.home),
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // No side-effect listeners needed here; errors are shown inline.
          },
          builder: (context, state) {
            // Trigger initial data fetch when BLoC is in initial state.
            if (state is HomeInitial) {
              context.read<HomeBloc>().add(const FetchHomeDataEvent());
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.lg),

                        // ── Header ─────────────────────────────────────────
                        if (state is HomeSuccess)
                          _HomeHeader(userName: state.data.userName)
                        else
                          const _HomeHeader(userName: ''),

                        const SizedBox(height: AppSpacing.lg),

                        // ── Order Concrete banner ──────────────────────────
                        const _OrderConcreteBanner(),

                        const SizedBox(height: AppSpacing.xl),

                        // ── Active Order section ───────────────────────────
                        _SectionHeader(
                          title: 'Active Order',
                          actionLabel: 'View Details',
                          onAction: () {},
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // ── Body: loading / success / error ────────────────
                        if (state is HomeLoading) ...[
                          // Shimmer placeholders while loading
                          _ShimmerOrderCard(),
                          const SizedBox(height: AppSpacing.md),
                          _ShimmerOrderCard(),
                        ] else if (state is HomeSuccess) ...[
                          // Real order cards from BLoC data
                          ...state.data.activeOrders.map(
                            (o) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _OrderCard(data: o),
                            ),
                          ),
                        ] else if (state is HomeError) ...[
                          // Error state with retry button
                          _HomeErrorWidget(message: state.message),
                        ],

                        // ── Note card ──────────────────────────────────────
                        if (state is HomeSuccess || state is HomeInitial) ...[
                          const _NoteCard(
                            text:
                                'Note: Orders above 100m³ require coordinator review and approval before scheduling.',
                          ),
                        ],

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Shimmer order card placeholder ────────────────────────────────────────────
class _ShimmerOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// ── Home error widget ─────────────────────────────────────────────────────────
class _HomeErrorWidget extends StatelessWidget {
  final String message;
  const _HomeErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(const FetchHomeDataEvent());
            },
            child: const Text('Retry'),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
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
/// Displays an [ActiveOrder] entity as a visual card.
class _OrderCard extends StatelessWidget {
  final ActiveOrder data;
  const _OrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final hasProgress = data.delivered != null && data.total != null;
    final progress = hasProgress ? data.delivered! / data.total! : 0.0;

    // Determine status badge from the string status value.
    final isInProgress = data.status == 'inProgress';

    // Format the amount as a currency string.
    final amountText =
        'AED ${data.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

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
              _StatusBadge(isInProgress: isInProgress),
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
                amountText,
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
  final bool isInProgress;
  const _StatusBadge({required this.isInProgress});

  @override
  Widget build(BuildContext context) {
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
