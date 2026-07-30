import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import 'domain/entities/order.dart' as order_entity;
import 'order_details_screen.dart';
import 'presentation/bloc/orders_bloc.dart';
import 'presentation/bloc/orders_event.dart';
import 'presentation/bloc/orders_state.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _pageBg = Color(0xFFF5F5F8);
const Color _cardBg = Colors.white;
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _textDark = Color(0xFF111111);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _orderIdColor = Color(0xFF7A6BFF);
const Color _inProgressBg = Color(0xFFFEF3C7);
const Color _inProgressText = Color(0xFFD97706);
const Color _scheduledBg = Color(0xFFEDE9FD);
const Color _scheduledText = Color(0xFF7A6BFF);
const Color _completedBg = Color(0xFFDCFCE7);
const Color _completedText = Color(0xFF16A34A);
const Color _progressTrack = Color(0xFFE5E7EB);
const Color _progressGreen = Color(0xFF22C55E);
const Color _progressBlue = Color(0xFF6366F1);

// ── Screen ────────────────────────────────────────────────────────────────────

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _searchCtrl = TextEditingController();

  static const _filters = ['All', 'Active', 'Scheduled', 'Completed'];

  @override
  void initState() {
    super.initState();
    // Trigger initial fetch when the screen is first created.
    context.read<OrdersBloc>().add(const FetchOrdersEvent());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      bottomNavigationBar: const AppTabBottomNavBar(currentTab: AppTab.orders),
      body: SafeArea(
        child: BlocConsumer<OrdersBloc, OrdersState>(
          listener: (context, state) {
            // Show snackbar on error state with a retry action.
            if (state is OrdersError) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      context
                          .read<OrdersBloc>()
                          .add(const RetryOrdersEvent());
                    },
                  ),
                ));
            }
          },
          builder: (context, state) {
            // Derive active filter index and search query from BLoC state.
            final filterIndex =
                state is OrdersSuccess ? state.filterIndex : 0;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Title
                        const Text(
                          'My Orders',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Track and manage your orders',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _textGrey,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Search bar — dispatches SearchOrdersEvent on change.
                        _SearchBar(
                          controller: _searchCtrl,
                          onChanged: (query) {
                            context
                                .read<OrdersBloc>()
                                .add(SearchOrdersEvent(query));
                          },
                        ),
                        const SizedBox(height: 14),

                        // Filter chips — dispatch FilterOrdersEvent on select.
                        _FilterRow(
                          filters: _filters,
                          selected: filterIndex,
                          onSelect: (i) {
                            context
                                .read<OrdersBloc>()
                                .add(FilterOrdersEvent(i));
                          },
                        ),
                        const SizedBox(height: 16),

                        // Body: loading / success / error / initial states.
                        if (state is OrdersLoading) ...[
                          // Shimmer placeholders while loading.
                          const _ShimmerOrderCard(),
                          const SizedBox(height: 12),
                          const _ShimmerOrderCard(),
                          const SizedBox(height: 12),
                          const _ShimmerOrderCard(),
                        ] else if (state is OrdersSuccess) ...[
                          // Real order cards from BLoC filtered list.
                          ...state.filteredOrders.map(
                            (o) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _OrderCard(
                                item: o,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const OrderDetailsScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (state.filteredOrders.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  'No orders found.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _textGrey,
                                  ),
                                ),
                              ),
                            ),
                        ] else if (state is OrdersError) ...[
                          // Inline retry widget shown alongside the snackbar.
                          _OrdersErrorWidget(message: state.message),
                        ] else if (state is OrdersInitial) ...[
                          // Optionally show a brief placeholder before fetch completes.
                          const SizedBox(height: 40),
                        ],

                        const SizedBox(height: 20),
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
  const _ShimmerOrderCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// ── Orders error widget ───────────────────────────────────────────────────────

class _OrdersErrorWidget extends StatelessWidget {
  final String message;
  const _OrdersErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: _textGrey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: _textGrey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<OrdersBloc>().add(const RetryOrdersEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;

  /// Callback invoked with the current query text on every change.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15, color: _textDark),
        decoration: InputDecoration(
          hintText: 'Search By Order ID..',
          hintStyle: const TextStyle(fontSize: 15, color: _textGrey),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 22,
            color: _textDark,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: _textDark, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: _textDark, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          filters.length,
          (i) => Padding(
            padding: EdgeInsets.only(right: i < filters.length - 1 ? 8 : 0),
            child: _FilterChip(
              label: filters[i],
              isSelected: i == selected,
              onTap: () => onSelect(i),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : _fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

// ── Order card ────────────────────────────────────────────────────────────────

/// Displays a domain [order_entity.Order] as a visual card.
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item, required this.onTap});

  final order_entity.Order item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasProgress =
        item.status == order_entity.OrderStatusType.inProgress &&
        item.delivered != null &&
        item.total != null;
    final progress = hasProgress ? item.delivered! / item.total! : 0.0;

    // Format the amount as a currency string with comma separators.
    final amountText =
        'AED ${item.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + status badge.
            Row(
              children: [
                Text(
                  item.orderId,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _orderIdColor,
                  ),
                ),
                const Spacer(),
                _StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: 6),

            // Grade.
            Text(
              item.grade,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),

            if (item.location.isNotEmpty) ...[
              const SizedBox(height: 10),
              _InfoRow(icon: Icons.location_on_outlined, text: item.location),
            ],
            if (item.timeSlot.isNotEmpty) ...[
              const SizedBox(height: 6),
              _InfoRow(icon: Icons.access_time_rounded, text: item.timeSlot),
            ],
            if (item.volume.isNotEmpty) ...[
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.local_shipping_outlined,
                text: item.volume,
              ),
            ],

            const SizedBox(height: 12),
            const Divider(color: _fieldBorder, height: 1),
            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  item.date,
                  style: const TextStyle(fontSize: 13, color: _textGrey),
                ),
                const Spacer(),
                Text(
                  amountText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
              ],
            ),

            if (hasProgress) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    'Delivered: ${item.delivered} m³',
                    style: const TextStyle(fontSize: 12, color: _textGrey),
                  ),
                  const Spacer(),
                  Text(
                    'Remaining: ${item.total! - item.delivered!} m³',
                    style: const TextStyle(fontSize: 12, color: _textGrey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _GradientProgressBar(progress: progress),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: _textGrey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: _textGrey),
          ),
        ),
      ],
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final order_entity.OrderStatusType status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;
    switch (status) {
      case order_entity.OrderStatusType.inProgress:
        bg = _inProgressBg;
        text = _inProgressText;
        label = 'in Progress';
        break;
      case order_entity.OrderStatusType.scheduled:
        bg = _scheduledBg;
        text = _scheduledText;
        label = 'Scheduled';
        break;
      case order_entity.OrderStatusType.completed:
        bg = _completedBg;
        text = _completedText;
        label = 'Completed';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}

// ── Gradient progress bar ─────────────────────────────────────────────────────

class _GradientProgressBar extends StatelessWidget {
  const _GradientProgressBar({required this.progress});
  final double progress;

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
