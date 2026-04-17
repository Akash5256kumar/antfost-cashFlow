import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark    = Color(0xFF1A1A1A);
const Color _textGrey    = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg      = Color(0xFFF2F2F7);
const Color _unreadDot   = Color(0xFF4F6BFF);

// ── Notification category ─────────────────────────────────────────────────────
enum NotifCategory { operational, financial, risk }

// ── Icon type ─────────────────────────────────────────────────────────────────
enum NotifIconType { truck, money, warning }

// ── Notification data model ───────────────────────────────────────────────────
class NotifItem {
  final String title;
  final String body;
  final String? orderId;
  final String timeAgo;
  final bool isUnread;
  final NotifCategory category;
  final NotifIconType iconType;

  const NotifItem({
    required this.title,
    required this.body,
    this.orderId,
    required this.timeAgo,
    required this.isUnread,
    required this.category,
    required this.iconType,
  });
}

// ── Sample data ───────────────────────────────────────────────────────────────
const _notifications = [
  NotifItem(
    title: 'Order Scheduled',
    body: 'Your order has been scheduled for 10 Feb 2026, 06:00 - 14:00',
    orderId: 'AF-2026-02-000001',
    timeAgo: '1d ago',
    isUnread: true,
    category: NotifCategory.operational,
    iconType: NotifIconType.truck,
  ),
  NotifItem(
    title: 'Truck Dispatched',
    body: 'Truck has been dispatched for order AF-2026-02-000001',
    orderId: 'AF-2026-02-000001',
    timeAgo: '1d ago',
    isUnread: true,
    category: NotifCategory.operational,
    iconType: NotifIconType.truck,
  ),
  NotifItem(
    title: 'Truck Arrived',
    body: 'Truck has arrived at Marina Heights Tower 3',
    orderId: 'AF-2026-02-000001',
    timeAgo: '23h ago',
    isUnread: false,
    category: NotifCategory.operational,
    iconType: NotifIconType.truck,
  ),
  NotifItem(
    title: 'Delivery Started',
    body: 'Concrete delivery is now in progress',
    orderId: 'AF-2026-02-000001',
    timeAgo: '23h ago',
    isUnread: false,
    category: NotifCategory.operational,
    iconType: NotifIconType.truck,
  ),
  NotifItem(
    title: 'Delivery Completed',
    body: 'Order AF-2026-02-000005 has been completed successfully',
    orderId: 'AF-2026-02-000005',
    timeAgo: '5d ago',
    isUnread: false,
    category: NotifCategory.operational,
    iconType: NotifIconType.truck,
  ),
  NotifItem(
    title: 'Delay Alert',
    body: 'Restricted zone access - traffic clearance required',
    orderId: 'AF-2026-02-000007',
    timeAgo: '19h ago',
    isUnread: true,
    category: NotifCategory.risk,
    iconType: NotifIconType.truck,
  ),
  NotifItem(
    title: 'Payment Received',
    body: 'AED 11,812.50 payment confirmed for order AF-2026-02-000001',
    orderId: 'AF-2026-02-000001',
    timeAgo: '2d ago',
    isUnread: false,
    category: NotifCategory.financial,
    iconType: NotifIconType.money,
  ),
  NotifItem(
    title: 'Wallet Updated',
    body: 'AED 500.00 added to your wallet',
    timeAgo: '3d ago',
    isUnread: false,
    category: NotifCategory.financial,
    iconType: NotifIconType.money,
  ),
  NotifItem(
    title: 'VAT Invoice Ready',
    body: 'Tax invoice is now available for order AF-2026-02-000002',
    orderId: 'AF-2026-02-000002',
    timeAgo: '2d ago',
    isUnread: false,
    category: NotifCategory.financial,
    iconType: NotifIconType.money,
  ),
  NotifItem(
    title: 'Refund Processed',
    body: 'AED 9,187.50 refunded for cancelled order AF-2026-02-000008',
    orderId: 'AF-2026-02-000008',
    timeAgo: '02 Feb',
    isUnread: false,
    category: NotifCategory.financial,
    iconType: NotifIconType.money,
  ),
  NotifItem(
    title: 'Allocation Delayed',
    body: 'Resource allocation delayed due to high demand',
    orderId: 'AF-2026-02-000007',
    timeAgo: '21h ago',
    isUnread: true,
    category: NotifCategory.risk,
    iconType: NotifIconType.warning,
  ),
  NotifItem(
    title: 'Restricted Zone Delay',
    body: 'Delivery delayed - restricted zone access approval pending',
    orderId: 'AF-2026-02-000007',
    timeAgo: '19h ago',
    isUnread: true,
    category: NotifCategory.risk,
    iconType: NotifIconType.warning,
  ),
  NotifItem(
    title: 'Payment Verification Pending',
    body: 'Payment verification in progress for order AF-2026-02-000006',
    orderId: 'AF-2026-02-000006',
    timeAgo: '1d ago',
    isUnread: false,
    category: NotifCategory.financial,
    iconType: NotifIconType.warning,
  ),
  NotifItem(
    title: 'Coordinator Assigned',
    body: 'Ahmed Al Mansouri will contact you regarding large-volume order',
    orderId: 'AF-2026-02-000004',
    timeAgo: '4d ago',
    isUnread: false,
    category: NotifCategory.operational,
    iconType: NotifIconType.warning,
  ),
];

const _filters = ['All', 'Operational', 'Financial', 'Risk'];

// ── Screen ────────────────────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filterIndex = 0;
  late List<NotifItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(_notifications);
  }

  List<NotifItem> get _filtered {
    if (_filterIndex == 0) return _items;
    final cat = NotifCategory.values[_filterIndex - 1];
    return _items.where((n) => n.category == cat).toList();
  }

  int get _unreadCount => _items.where((n) => n.isUnread).length;

  void _clearAll() => setState(() {
        _items = _items.map((n) => NotifItem(
              title: n.title,
              body: n.body,
              orderId: n.orderId,
              timeAgo: n.timeAgo,
              isUnread: false,
              category: n.category,
              iconType: n.iconType,
            )).toList();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _NotifAppBar(unreadCount: _unreadCount),

            // Filter row + Clear All
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => _FilterChip(
                          label: _filters[i],
                          isSelected: _filterIndex == i,
                          onTap: () => setState(() => _filterIndex = i),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearAll,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Notification list
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications',
                        style: TextStyle(fontSize: 14, color: _textGrey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _NotifCard(item: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _NotifAppBar extends StatelessWidget {
  const _NotifAppBar({required this.unreadCount});
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$unreadCount unread',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
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
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }
}

// ── Notification card ─────────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item});
  final NotifItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isUnread ? AppColors.primary : _fieldBorder,
          width: item.isUnread ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          _NotifIcon(type: item.iconType),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row + unread dot
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (item.isUnread) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: _unreadDot,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Body
                Text(
                  item.body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textGrey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 6),

                // Order ID + time
                Row(
                  children: [
                    if (item.orderId != null)
                      Expanded(
                        child: Text(
                          item.orderId!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textGrey,
                            height: 1.3,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification icon ─────────────────────────────────────────────────────────
class _NotifIcon extends StatelessWidget {
  const _NotifIcon({required this.type});
  final NotifIconType type;

  @override
  Widget build(BuildContext context) {
    final (bg, icon, color) = switch (type) {
      NotifIconType.truck => (
          const Color(0xFFFFF3E0),
          Icons.local_shipping_rounded,
          const Color(0xFFE65100),
        ),
      NotifIconType.money => (
          const Color(0xFFF5F5F5),
          Icons.account_balance_wallet_rounded,
          const Color(0xFF757575),
        ),
      NotifIconType.warning => (
          const Color(0xFFFFF0F5),
          Icons.warning_rounded,
          const Color(0xFFFF5CA8),
        ),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }
}
