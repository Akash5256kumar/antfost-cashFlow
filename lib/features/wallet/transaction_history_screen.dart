import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark   = Color(0xFF1A1A1A);
const Color _textGrey   = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg     = Color(0xFFF2F2F7);

// ── Transaction status enum ───────────────────────────────────────────────────
enum TxStatus { completed, reserved, pending, failed, refunded }

// ── Transaction data model ────────────────────────────────────────────────────
class TxItem {
  final String id;
  final String name;
  final String date;
  final double amount;
  final TxStatus status;
  final bool isCredit;

  const TxItem({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.status,
    required this.isCredit,
  });
}

// ── Sample data ───────────────────────────────────────────────────────────────
const _transactions = [
  TxItem(
    id: 'TX-001',
    name: 'Order AF-2026-02-000123',
    date: '10 Feb 2026, 9:14 AM',
    amount: 11962.50,
    status: TxStatus.completed,
    isCredit: false,
  ),
  TxItem(
    id: 'TX-002',
    name: 'Wallet Top-up',
    date: '8 Feb 2026, 3:00 PM',
    amount: 5000.00,
    status: TxStatus.completed,
    isCredit: true,
  ),
  TxItem(
    id: 'TX-003',
    name: 'Order AF-2026-02-000098',
    date: '6 Feb 2026, 7:45 AM',
    amount: 9450.00,
    status: TxStatus.reserved,
    isCredit: false,
  ),
  TxItem(
    id: 'TX-004',
    name: 'Order AF-2026-01-000077',
    date: '28 Jan 2026, 11:20 AM',
    amount: 17400.00,
    status: TxStatus.pending,
    isCredit: false,
  ),
  TxItem(
    id: 'TX-005',
    name: 'Refund - Cancelled Order',
    date: '20 Jan 2026, 2:10 PM',
    amount: 3200.00,
    status: TxStatus.refunded,
    isCredit: true,
  ),
  TxItem(
    id: 'TX-006',
    name: 'Order AF-2026-01-000055',
    date: '15 Jan 2026, 8:00 AM',
    amount: 8750.00,
    status: TxStatus.failed,
    isCredit: false,
  ),
  TxItem(
    id: 'TX-007',
    name: 'Order AF-2026-01-000031',
    date: '5 Jan 2026, 9:30 AM',
    amount: 21000.00,
    status: TxStatus.completed,
    isCredit: false,
  ),
];

// ── Filter chips data ─────────────────────────────────────────────────────────
const _filters = ['All', 'Deposits', 'Spends', 'Reserved'];

// ── Screen ────────────────────────────────────────────────────────────────────
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  int _filterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TxItem> get _filtered {
    final query = _searchController.text.toLowerCase();
    var list = _transactions.where((t) {
      if (query.isNotEmpty) {
        return t.id.toLowerCase().contains(query) ||
            t.name.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    switch (_filterIndex) {
      case 1: // Deposits
        list = list.where((t) => t.isCredit).toList();
        break;
      case 2: // Spends
        list = list
            .where((t) => !t.isCredit && t.status != TxStatus.reserved)
            .toList();
        break;
      case 3: // Reserved
        list = list.where((t) => t.status == TxStatus.reserved).toList();
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _TxAppBar(),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _SearchBar(controller: _searchController, onChanged: (_) => setState(() {})),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => _FilterChipItem(
                    label: _filters[i],
                    isSelected: _filterIndex == i,
                    onTap: () => setState(() => _filterIndex = i),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Transaction list
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions found',
                        style: TextStyle(fontSize: 14, color: _textGrey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _TransactionRow(item: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _TxAppBar extends StatelessWidget {
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'All wallet transactions',
                style: TextStyle(
                  fontSize: 14,
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

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, size: 20, color: _textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: _textDark,
              ),
              decoration: const InputDecoration(
                hintText: 'Search By Order ID or type',
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────
class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
          ),
        ),
      ),
    );
  }
}

// ── Transaction row ───────────────────────────────────────────────────────────
class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.item});
  final TxItem item;

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor) = _statusColors(item.status);
    final amountStr = _formatAmount(item.amount);
    final prefix = item.isCredit ? '+' : '-';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),

          // Name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _textGrey,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Amount + status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$prefix AED $amountStr',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: item.isCredit
                      ? const Color(0xFF16A34A)
                      : _textDark,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(item.status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: fgColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static (Color, Color) _statusColors(TxStatus s) {
    switch (s) {
      case TxStatus.completed:
        return (const Color(0xFFDCFCE7), const Color(0xFF16A34A));
      case TxStatus.reserved:
        return (const Color(0xFFEDE9FD), const Color(0xFF7A6BFF));
      case TxStatus.pending:
        return (const Color(0xFFFEF3C7), const Color(0xFFD97706));
      case TxStatus.failed:
        return (const Color(0xFFFFE4EE), const Color(0xFFFF5CA8));
      case TxStatus.refunded:
        return (const Color(0xFFEDE9FD), const Color(0xFF7A6BFF));
    }
  }

  static String _statusLabel(TxStatus s) {
    switch (s) {
      case TxStatus.completed: return 'Completed';
      case TxStatus.reserved:  return 'Reserved';
      case TxStatus.pending:   return 'Pending';
      case TxStatus.failed:    return 'Failed';
      case TxStatus.refunded:  return 'Refunded';
    }
  }

  static String _formatAmount(double v) {
    final intPart = v.truncate();
    final fracPart = ((v - intPart) * 100).round();
    final s = intPart.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    buf.write('.');
    buf.write(fracPart.toString().padLeft(2, '0'));
    return buf.toString();
  }
}
