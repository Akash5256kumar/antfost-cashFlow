import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../payment/payment_screen.dart';
import '../../core/services/app_demo_service.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_location_thumb.dart';
import '../../core/widgets/app_remote_image.dart';
import '../../core/widgets/app_status_badge.dart';
import '../../core/widgets/primary_button.dart';
import 'domain/entities/home_data.dart';
import 'presentation/bloc/home_bloc.dart';
import 'presentation/bloc/home_event.dart';
import 'presentation/bloc/home_state.dart';

/// Ported from the new Figma design's `screens/Home.tsx`: a branded header,
/// account status, two stat cards, a hero CTA, and Recent Orders.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.verificationUnderReview = false});

  final bool verificationUnderReview;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch after the first frame so the auth token is guaranteed
    // to be persisted before the API call fires. This fixes the race condition
    // where navigating from SignIn immediately triggers a 401 Unauthenticated.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeBloc>().add(const FetchHomeDataEvent());
      // Clear any lingering snackbars from previous screens.
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBrandHeader(
        onBellTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      bottomNavigationBar: const AppTabBottomNavBar(currentTab: AppTab.home),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final activeOrders = state is HomeSuccess
              ? state.data.activeOrders
              : const <ActiveOrder>[];
          final isBusiness =
              state is HomeSuccess &&
              state.data.accountType.toLowerCase() == 'business';

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const FetchHomeDataEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.scaledV(4)),
                if (AppDemoService.isDemoMode) ...[
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        AppDemoService.setDemoMode(false);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.signIn,
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaled(14),
                          vertical: context.scaledV(6),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(context.scaled(20)),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_fill_rounded,
                              size: context.scaled(16),
                              color: const Color(0xFF2563EB),
                            ),
                            SizedBox(width: context.scaled(6)),
                            Text(
                              'Demo Mode • Tap to Sign In',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(10)),
                ] else if (isBusiness) ...[
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.kycVerificationStatus);
                      },
                      child: AppStatusBadge(
                        label: widget.verificationUnderReview
                            ? 'Under Review'
                            : 'Approved',
                        tone: widget.verificationUnderReview
                            ? AppStatusTone.review
                            : AppStatusTone.active,
                        showIcon: true,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(14)),
                ],
                Text(
                  state is HomeSuccess
                      ? 'Good afternoon, ${state.data.userName}'
                      : 'Good afternoon',
                  style: AppTextStyles.authScreenTitle(context).copyWith(
                    fontSize: context.scaled(20),
                    height: 1.15,
                    letterSpacing: 0,
                  ),
                ),
                if (widget.verificationUnderReview) ...[
                  SizedBox(height: context.scaledV(6)),
                  Text(
                    'Business verification in review - Payments activate after approval',
                    style: AppTextStyles.cardSubtitle(context).copyWith(
                      color: AppColors.textSecondary,
                      fontSize: context.scaled(11),
                      height: 1.25,
                    ),
                  ),
                ],
                SizedBox(height: context.scaledV(16)),
                if (state is HomeLoading)
                  const _ShimmerBlock(height: 76)
                else if (state is HomeSuccess)
                  _StatsRow(
                    orders: activeOrders,
                    projectCount: state.data.projectCount,
                  )
                else
                  const SizedBox.shrink(),
                SizedBox(height: context.scaledV(16)),
                const _HeroBanner(),
                SizedBox(height: context.scaledV(22)),
                Text(
                  'Recent Orders',
                  style: AppTextStyles.authScreenTitle(
                    context,
                  ).copyWith(fontSize: context.scaled(18)),
                ),
                SizedBox(height: context.scaledV(12)),
                if (state is HomeLoading) ...[
                  const _ShimmerBlock(height: 200),
                ] else if (state is HomeSuccess) ...[
                  if (activeOrders.isEmpty)
                    const _EmptyOrders()
                  else
                    _RecentOrdersList(orders: activeOrders),
                ] else if (state is HomeError) ...[
                  _HomeErrorWidget(message: state.message),
                ],
                SizedBox(height: context.scaledV(28)),
              ],
            ),
          ),
        );
      },
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.circleInactive,
      highlightColor: AppColors.muted,
      child: Container(
        height: context.scaled(height),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _HomeErrorWidget extends StatelessWidget {
  final String message;
  const _HomeErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.scaledV(16)),
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.scaledV(12)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.cardSubtitle(context),
          ),
          SizedBox(height: context.scaledV(16)),
          TextButton(
            onPressed: () =>
                context.read<HomeBloc>().add(const FetchHomeDataEvent()),
            child: const Text('Retry'),
          ),
          SizedBox(height: context.scaledV(16)),
        ],
      ),
    );
  }
}

// ── Stat cards ("Projects" / "Active Orders") ──────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.orders, required this.projectCount});

  final List<ActiveOrder> orders;
  final int projectCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.business_rounded,
            label: 'Projects',
            value: '$projectCount',
            onTap: () => AppTabControllerScope.of(
              context,
            ).onSelectTab(AppTab.projects.index),
          ),
        ),
        SizedBox(width: AppSpacing.md(context)),
        Expanded(
          child: _StatCard(
            icon: Icons.assignment_outlined,
            label: 'Active Orders',
            value: '${orders.length}',
            onTap: () => AppTabControllerScope.of(
              context,
            ).onSelectTab(AppTab.orders.index),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.scaledV(82),
        padding: EdgeInsets.symmetric(horizontal: context.scaled(12)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.scaled(18)),
          border: Border.all(color: const Color(0xFFE7E8F2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.025),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: context.scaled(42),
              height: context.scaled(42),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: context.scaled(20),
                color: AppColors.primary,
              ),
            ),

            SizedBox(width: context.scaled(9)),

            Expanded(
              child: Transform.translate(
                offset: Offset(0, -context.scaledV(3)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.cardSubtitle(context).copyWith(
                        fontSize: context.scaled(11),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.15,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(height: context.scaledV(2)),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: context.scaled(26),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 0.95,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              size: context.scaled(22),
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero banner ─────────────────────────────────────────────────────────────
// Ported from Figma's Home.tsx hero card: artwork stays fully visible while
// the heading and CTA remain pinned in place.
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFFF3F5FD);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(context.scaled(20)),
        border: Border.all(color: const Color(0xFFE2E7FA)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: context.scaledV(200),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppRemoteImage.screen(
                  screenKey: 'homeHeader',
                  fallback: AppAssets.artHomeHero,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 14,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          cardBgColor.withValues(alpha: 0.0),
                          cardBgColor.withValues(alpha: 0.35),
                          cardBgColor,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: context.scaled(16),
                  top: context.scaledV(14),
                  child: Text(
                    'Ready for\nyour next pour?',
                    style: TextStyle(
                      fontSize: context.scaled(20),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      height: 1.15,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: PrimaryButton(
              arrow: true,
              label: 'Create New Project',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.addNewProject),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent orders list ──────────────────────────────────────────────────────
class _RecentOrdersList extends StatelessWidget {
  const _RecentOrdersList({required this.orders});
  final List<ActiveOrder> orders;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(orders.length, (i) {
          final order = orders[i];
          return Column(
            children: [
              if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
              _RecentOrderRow(order: order),
            ],
          );
        }),
      ),
    );
  }
}

class _RecentOrderRow extends StatelessWidget {
  const _RecentOrderRow({required this.order});
  final ActiveOrder order;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = order.status.trim().toLowerCase();
    final badgeLabel = switch (normalizedStatus) {
      'inprogress' => 'On the way',
      'confirmationneeded' => 'Confirmation\nneeded',
      'pending' => 'Pending payment',
      'draft' => 'Draft',
      _ => 'Scheduled',
    };
    final badgeTone = switch (normalizedStatus) {
      'inprogress' => AppStatusTone.onWay,
      'confirmationneeded' => AppStatusTone.confirm,
      'pending' => AppStatusTone.review,
      'draft' => AppStatusTone.review,
      _ => AppStatusTone.scheduled,
    };

    return InkWell(
      onTap: () {
        if (normalizedStatus == 'pending' || normalizedStatus == 'draft') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PaymentScreen(
                orderId: order.orderId,
                orderRef: order.orderReference?.isNotEmpty == true
                    ? order.orderReference!
                    : 'AF-${order.orderId}',
                totalAmount: order.amount,
                quantity: int.tryParse(
                      order.volume.replaceAll(RegExp(r'[^0-9]'), ''),
                    ) ??
                    1,
                mixCode: order.grade,
                projectName: order.location.isNotEmpty
                    ? order.location
                    : (order.projectName ?? ''),
              ),
            ),
          );
          return;
        }
        Navigator.of(context).pushNamed(
          AppRoutes.orderDetails,
          arguments: order.orderId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AppLocationThumb(
              location: order.location.isNotEmpty
                  ? order.location
                  : (order.projectName ?? 'Location'),
              imageUrl: order.imageUrl,
            ),
            SizedBox(width: AppSpacing.md(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.location.isNotEmpty
                        ? order.location
                        : (order.projectName ?? 'Concrete Order'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle(
                      context,
                    ).copyWith(fontSize: context.scaled(13)),
                  ),
                  Text(
                    order.orderReference?.isNotEmpty == true
                        ? order.orderReference!
                        : 'Order ${order.orderId}',
                    style: AppTextStyles.cardSubtitle(context),
                  ),
                ],
              ),
            ),
            AppStatusBadge(label: badgeLabel, tone: badgeTone),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: context.scaledV(32)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.assignment_outlined,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.scaledV(12)),
          Text('No orders yet', style: AppTextStyles.cardTitle(context)),
          SizedBox(height: context.scaledV(4)),
          Text(
            'Your first order will appear here',
            style: AppTextStyles.cardSubtitle(context),
          ),
        ],
      ),
    );
  }
}
