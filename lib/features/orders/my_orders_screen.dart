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
import '../../core/widgets/app_chips_row.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_status_badge.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';
import 'domain/entities/order.dart' as order_entity;
import 'order_details_screen.dart';
import '../payment/price_breakdown_screen.dart';
import 'presentation/bloc/orders_bloc.dart';
import 'presentation/bloc/orders_event.dart';
import 'presentation/bloc/orders_state.dart';

/// Ported from the new Figma design's `screens/Orders.tsx` — a search bar,
/// filter chips, and a compact single-tap order list (the whole row routes
/// to the right screen for that order's status, matching the existing
/// per-status navigation this app already had).
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _searchCtrl = TextEditingController();

  static const _filters = ['All', 'Active', 'Confirmation needed', 'Completed'];

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(const FetchOrdersEvent());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openOrder(order_entity.Order o) {
    // Drafts/awaiting-payment orders have not entered fulfilment. ContinueR
    // their payment journey instead of presenting delivery tracking.
    if (o.status == order_entity.OrderStatusType.draft ||
        o.status == order_entity.OrderStatusType.pending) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PriceBreakdownScreen(
            orderId: o.orderId,
            projectName: o.location,
            mixCode: o.grade,
            quantity:
                int.tryParse(o.volume.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
            deliveryDate: o.date,
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            OrderDetailsScreen(orderId: o.orderId, projectName: o.location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBrandHeader(
        onBellTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      bottomNavigationBar: const AppTabBottomNavBar(currentTab: AppTab.orders),
      body: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state is OrdersError) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () => context.read<OrdersBloc>().add(
                      const RetryOrdersEvent(),
                    ),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          final filterIndex = state is OrdersSuccess ? state.filterIndex : 0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.scaledV(4)),
                Text(
                  'My Orders',
                  style: AppTextStyles.authScreenTitle(
                    context,
                  ).copyWith(fontSize: context.scaled(25)),
                ),
                SizedBox(height: context.scaledV(14)),
                _SearchField(
                  controller: _searchCtrl,
                  onChanged: (q) =>
                      context.read<OrdersBloc>().add(SearchOrdersEvent(q)),
                ),
                SizedBox(height: context.scaledV(14)),
                AppChipsRow(
                  options: _filters,
                  value: _filters[filterIndex],
                  onChanged: (label) => context.read<OrdersBloc>().add(
                    FilterOrdersEvent(_filters.indexOf(label)),
                  ),
                ),
                SizedBox(height: context.scaledV(14)),
                if (state is OrdersLoading) ...[
                  const _ShimmerOrderCard(),
                  SizedBox(height: context.scaledV(10)),
                  const _ShimmerOrderCard(),
                ] else if (state is OrdersSuccess) ...[
                  if (state.filteredOrders.isEmpty)
                    const _EmptyOrders()
                  else
                    ...state.filteredOrders.map(
                      (o) => Padding(
                        padding: EdgeInsets.only(bottom: context.scaledV(10)),
                        child: _OrderRow(order: o, onTap: () => _openOrder(o)),
                      ),
                    ),
                ] else if (state is OrdersError) ...[
                  _OrdersErrorWidget(message: state.message),
                ],
                SizedBox(height: context.scaledV(14)),
                _CreateOrderButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.addNewProject),
                ),
                SizedBox(height: context.scaledV(10)),
                Center(
                  child: TextButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.orderGuide),
                    icon: const Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    label: Text(
                      'How ordering works',
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(20)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: context.scaled(14),
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search order or project',
          hintStyle: TextStyle(
            fontSize: context.scaled(14),
            color: AppColors.textHint,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.iconMuted,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _CreateOrderButton extends StatelessWidget {
  const _CreateOrderButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline_rounded,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              const Text(
                'Create New Order',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerOrderCard extends StatelessWidget {
  const _ShimmerOrderCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.circleInactive,
      highlightColor: AppColors.muted,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _OrdersErrorWidget extends StatelessWidget {
  final String message;
  const _OrdersErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.scaledV(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: context.scaledV(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardSubtitle(context),
            ),
            SizedBox(height: context.scaledV(16)),
            TextButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(const RetryOrdersEvent()),
              child: const Text('Retry'),
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
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
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
            child: const Icon(Icons.search_rounded, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text('No orders found', style: AppTextStyles.cardTitle(context)),
          const SizedBox(height: 4),
          Text(
            'Try another order number or project name.',
            style: AppTextStyles.cardSubtitle(context),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, required this.onTap});
  final order_entity.Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool needsConfirmation =
        order.status == order_entity.OrderStatusType.inProgress &&
        (order.delivered == null || order.delivered == 0);

    final (tone, label) = needsConfirmation
        ? (AppStatusTone.confirm, 'Confirmation needed')
        : switch (order.status) {
            order_entity.OrderStatusType.scheduled => (
              AppStatusTone.scheduled,
              'Scheduled',
            ),
            order_entity.OrderStatusType.inProgress => (
              AppStatusTone.onWay,
              'On the way',
            ),
            order_entity.OrderStatusType.completed => (
              AppStatusTone.completed,
              'Completed',
            ),
            order_entity.OrderStatusType.draft => (
              AppStatusTone.review,
              'Draft',
            ),
            order_entity.OrderStatusType.pending => (
              AppStatusTone.review,
              'Pending',
            ),
            order_entity.OrderStatusType.confirmed => (
              AppStatusTone.scheduled,
              'Confirmed',
            ),
          };
    final thumbnail = AppAssets.orderThumbnailFor(
      order.orderId,
      order.location,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: order.imageUrl?.startsWith('http') == true
                  ? Image.network(
                      order.imageUrl!,
                      width: 94,
                      height: 94,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => SvgEmbeddedRasterImage(
                        assetPath: thumbnail,
                        width: 94,
                        height: 94,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SvgEmbeddedRasterImage(
                      assetPath: thumbnail,
                      width: 94,
                      height: 94,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderId,
                        style: TextStyle(
                          fontSize: context.scaled(16),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.volume,
                        style: TextStyle(
                          fontSize: context.scaled(15),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order.date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.scaled(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      AppStatusBadge(label: label, tone: tone),
                    ],
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
