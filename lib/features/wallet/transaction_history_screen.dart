import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg = Color(0xFFF2F2F7);

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
              padding: EdgeInsets.fromLTRB(
                context.scaled(16),
                context.scaledV(12),
                context.scaled(16),
                0,
              ),
              child: _SearchBar(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),

            // Filter chips
            Padding(
              padding: EdgeInsets.fromLTRB(0, context.scaledV(10), 0, 0),
              child: SizedBox(
                height: context.scaledV(34),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: context.scaled(16)),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: context.scaled(8)),
                  itemBuilder: (_, i) => _FilterChipItem(
                    label: _filters[i],
                    isSelected: _filterIndex == i,
                    onTap: () => setState(() => _filterIndex = i),
                  ),
                ),
              ),
            ),

            SizedBox(height: context.scaledV(16)),

            // Transaction list
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions found',
                        style: TextStyle(
                          fontSize: context.scaled(14),
                          color: _textGrey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        context.scaled(16),
                        0,
                        context.scaled(16),
                        context.scaled(32),
                      ),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: context.scaledV(10)),
                      itemBuilder: (_, i) =>
                          _TransactionRow(item: _filtered[i]),
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
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaledV(8),
        context.scaled(16),
        context.scaledV(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.scaled(40),
            height: context.scaled(40),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back_rounded, size: context.scaled(22)),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(width: context.scaled(6)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: context.scaled(18),
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: context.scaledV(2)),
                Text(
                  'All wallet transactions',
                  style: TextStyle(
                    fontSize: context.scaled(12.5),
                    fontWeight: FontWeight.w400,
                    color: _textGrey,
                    height: 1.2,
                  ),
                ),
              ],
            ),
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
      height: context.scaledV(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(24)),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          SizedBox(width: context.scaled(14)),
          Icon(
            Icons.search_rounded,
            size: context.scaled(19),
            color: _textGrey,
          ),
          SizedBox(width: context.scaled(8)),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: context.scaled(13.5),
                fontWeight: FontWeight.w400,
                color: _textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Search By Order ID or type',
                hintStyle: TextStyle(
                  fontSize: context.scaled(13.5),
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: context.scaledV(8),
                ),
              ),
            ),
          ),
          SizedBox(width: context.scaled(14)),
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
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(16),
          vertical: context.scaledV(7),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(20)),
          border: Border.all(
            color: isSelected ? AppColors.primary : _fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(13),
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
      padding: EdgeInsets.all(context.scaled(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(14)),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            width: context.scaled(40),
            height: context.scaled(40),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(context.scaled(10)),
            ),
            child: Icon(
              item.isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: context.scaled(20),
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: context.scaled(10)),

          // Name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: context.scaled(13.5),
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: context.scaledV(3)),
                Text(
                  item.date,
                  style: TextStyle(
                    fontSize: context.scaled(11.5),
                    fontWeight: FontWeight.w400,
                    color: _textGrey,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.scaled(8)),

          // Amount + status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$prefix AED $amountStr',
                style: TextStyle(
                  fontSize: context.scaled(13.5),
                  fontWeight: FontWeight.w700,
                  color: item.isCredit ? const Color(0xFF16A34A) : _textDark,
                  height: 1.25,
                ),
              ),
              SizedBox(height: context.scaledV(4)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(8),
                  vertical: context.scaledV(2.5),
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(context.scaled(16)),
                ),
                child: Text(
                  _statusLabel(item.status),
                  style: TextStyle(
                    fontSize: context.scaled(10.5),
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
        return (AppColors.primaryContainer, AppColors.primary);
      case TxStatus.pending:
        return (const Color(0xFFFEF3C7), const Color(0xFFD97706));
      case TxStatus.failed:
        return (const Color(0xFFFFE4EE), const Color(0xFFFF5CA8));
      case TxStatus.refunded:
        return (AppColors.primaryContainer, AppColors.primary);
    }
  }

  static String _statusLabel(TxStatus s) {
    switch (s) {
      case TxStatus.completed:
        return 'Completed';
      case TxStatus.reserved:
        return 'Reserved';
      case TxStatus.pending:
        return 'Pending';
      case TxStatus.failed:
        return 'Failed';
      case TxStatus.refunded:
        return 'Refunded';
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
