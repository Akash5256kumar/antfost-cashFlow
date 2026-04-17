import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'order_details_screen.dart';

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

// ── Status enum ───────────────────────────────────────────────────────────────

enum OrderStatusType { inProgress, scheduled, completed }

// ── Data model ────────────────────────────────────────────────────────────────

class MyOrderItem {
  const MyOrderItem({
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

  final String orderId;
  final OrderStatusType status;
  final String grade;
  final String location;
  final String timeSlot;
  final String volume;
  final String date;
  final String amount;
  final int? delivered;
  final int? total;
}

const _allOrders = [
  MyOrderItem(
    orderId: 'AF-2024-02-000001',
    status: OrderStatusType.inProgress,
    grade: 'C25/30',
    location: 'Marina Tower - Ground Floor',
    timeSlot: '6 AM - 10 AM (±4 hrs)',
    volume: '50 m³ • 5 trips',
    date: '7 Feb, 10:06 AM',
    amount: 'AED 17,400',
    delivered: 20,
    total: 50,
  ),
  MyOrderItem(
    orderId: 'AF-2024-02-000002',
    status: OrderStatusType.scheduled,
    grade: 'C30/37',
    location: 'Palm Villa Site A',
    timeSlot: '6 AM - 12 PM (±6 hrs)',
    volume: '25 m³ • 3 trips',
    date: '6 Feb, 12:06 PM',
    amount: 'AED 9,450',
  ),
  MyOrderItem(
    orderId: 'AF-2024-02-000002',
    status: OrderStatusType.completed,
    grade: 'C30/37',
    location: 'Palm Villa Site A',
    timeSlot: '',
    volume: '',
    date: '6 Feb, 12:06 PM',
    amount: 'AED 9,450',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _filterIndex = 0; // 0=All, 1=Active, 2=Scheduled, 3=Completed
  final _searchCtrl = TextEditingController();

  static const _filters = ['All', 'Active', 'Scheduled', 'Completed'];

  List<MyOrderItem> get _filtered {
    var items = _allOrders.toList();
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items
          .where(
            (o) =>
                o.orderId.toLowerCase().contains(q) ||
                o.grade.toLowerCase().contains(q),
          )
          .toList();
    }
    switch (_filterIndex) {
      case 1:
        items = items
            .where((o) => o.status == OrderStatusType.inProgress)
            .toList();
        break;
      case 2:
        items = items
            .where((o) => o.status == OrderStatusType.scheduled)
            .toList();
        break;
      case 3:
        items = items
            .where((o) => o.status == OrderStatusType.completed)
            .toList();
        break;
    }
    return items;
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
      body: SafeArea(
        child: Column(
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

                    // Search bar
                    _SearchBar(controller: _searchCtrl),
                    const SizedBox(height: 14),

                    // Filter chips
                    _FilterRow(
                      filters: _filters,
                      selected: _filterIndex,
                      onSelect: (i) => setState(() => _filterIndex = i),
                    ),
                    const SizedBox(height: 16),

                    // Order cards
                    ..._filtered.map(
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

                    const SizedBox(height: 20),
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

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
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

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item, required this.onTap});
  final MyOrderItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasProgress =
        item.status == OrderStatusType.inProgress &&
        item.delivered != null &&
        item.total != null;
    final progress = hasProgress ? item.delivered! / item.total! : 0.0;

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
            // Order ID + status
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

            // Grade
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
              _InfoRow(icon: Icons.local_shipping_outlined, text: item.volume),
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
                  item.amount,
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final OrderStatusType status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;
    switch (status) {
      case OrderStatusType.inProgress:
        bg = _inProgressBg;
        text = _inProgressText;
        label = 'in Progress';
        break;
      case OrderStatusType.scheduled:
        bg = _scheduledBg;
        text = _scheduledText;
        label = 'Scheduled';
        break;
      case OrderStatusType.completed:
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
