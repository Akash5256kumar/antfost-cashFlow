import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'invoice_details_screen.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark    = Color(0xFF1A1A1A);
const Color _textGrey    = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg      = Color(0xFFF2F2F7);
const Color _iconBg      = Color(0xFFF1F1F1);

// ── Invoice type / status enums ───────────────────────────────────────────────
enum InvoiceType { vat, receipt }
enum InvoiceStatus { paid, vatInvoiceReady, sent, draft }

// ── Data model ────────────────────────────────────────────────────────────────
class InvoiceItem {
  final String id;
  final String orderId;
  final double totalAmount;
  final String date;
  final List<InvoiceType> types;
  final InvoiceStatus status;

  const InvoiceItem({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.date,
    required this.types,
    required this.status,
  });
}

// ── Sample data ───────────────────────────────────────────────────────────────
const _invoices = [
  InvoiceItem(
    id: 'INV-2026-02-00001',
    orderId: 'ord-001',
    totalAmount: 22785.00,
    date: '9 Feb 2026',
    types: [InvoiceType.vat],
    status: InvoiceStatus.paid,
  ),
  InvoiceItem(
    id: 'INV-2026-02-00002',
    orderId: 'ord-002',
    totalAmount: 15120.00,
    date: '8 Feb 2026',
    types: [],
    status: InvoiceStatus.vatInvoiceReady,
  ),
  InvoiceItem(
    id: 'INV-2026-02-00003',
    orderId: 'ord-003',
    totalAmount: 53760.00,
    date: '7 Feb 2026',
    types: [InvoiceType.vat],
    status: InvoiceStatus.sent,
  ),
  InvoiceItem(
    id: 'INV-2026-02-00004',
    orderId: 'ord-004',
    totalAmount: 7087.50,
    date: '9 Feb 2026',
    types: [InvoiceType.vat],
    status: InvoiceStatus.draft,
  ),
  InvoiceItem(
    id: 'INV-2026-02-00001',
    orderId: 'ord-001',
    totalAmount: 22785.00,
    date: '9 Feb 2026',
    types: [InvoiceType.vat],
    status: InvoiceStatus.paid,
  ),
];

const _filters = ['All', 'Receipts', 'VAT Invoices', 'Ready'];

// ── Screen ────────────────────────────────────────────────────────────────────
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  int _filterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InvoiceItem> get _filtered {
    final q = _searchController.text.toLowerCase();
    return _invoices.where((inv) {
      if (q.isNotEmpty) {
        return inv.id.toLowerCase().contains(q) ||
            inv.orderId.toLowerCase().contains(q);
      }
      switch (_filterIndex) {
        case 1:
          return inv.types.contains(InvoiceType.receipt);
        case 2:
          return inv.types.contains(InvoiceType.vat);
        case 3:
          return inv.status == InvoiceStatus.vatInvoiceReady;
        default:
          return true;
      }
    }).toList();
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
            _InvoicesAppBar(),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _SearchBar(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
              child: SizedBox(
                height: 38,
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

            const SizedBox(height: 16),

            // List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _InvoiceCard(
                  item: _filtered[i],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          InvoiceDetailsScreen(invoice: _filtered[i]),
                    ),
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

// ── App bar ───────────────────────────────────────────────────────────────────
class _InvoicesAppBar extends StatelessWidget {
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
          const Text(
            'Invoices',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _textDark,
              height: 1.2,
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
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF111111), width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, size: 22, color: _textDark),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16, color: _textDark),
              decoration: const InputDecoration(
                hintText: 'Search By Order ID or type',
                hintStyle: TextStyle(fontSize: 16, color: _textGrey),
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

// ── Invoice card ──────────────────────────────────────────────────────────────
class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.item, required this.onTap});
  final InvoiceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + id + badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 22,
                    color: _textGrey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.id,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order ID: ${item.orderId}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: _textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _BadgesRow(types: item.types, status: item.status),
              ],
            ),

            const SizedBox(height: 14),

            // Total amount + date
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AED ${_fmt(item.totalAmount)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textGrey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) {
    final i = v.truncate();
    final f = ((v - i) * 100).round();
    final s = i.toString();
    final buf = StringBuffer();
    for (var k = 0; k < s.length; k++) {
      if (k > 0 && (s.length - k) % 3 == 0) buf.write(',');
      buf.write(s[k]);
    }
    buf.write('.');
    buf.write(f.toString().padLeft(2, '0'));
    return buf.toString();
  }
}

// ── Badges row ────────────────────────────────────────────────────────────────
class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.types, required this.status});
  final List<InvoiceType> types;
  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == InvoiceStatus.vatInvoiceReady) {
      return _Badge(label: 'VAT Invoice Ready', bg: const Color(0xFFEDE9FB), fg: AppColors.primary);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (types.contains(InvoiceType.vat)) ...[
          _Badge(label: 'VAT', bg: const Color(0xFFEDE9FB), fg: AppColors.primary),
          const SizedBox(width: 6),
        ],
        _StatusBadge(status: status),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      InvoiceStatus.paid =>
        ('Paid', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
      InvoiceStatus.sent =>
        ('Sent', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
      InvoiceStatus.draft =>
        ('Draft', const Color(0xFFF1F1F1), _textDark),
      InvoiceStatus.vatInvoiceReady =>
        ('Ready', const Color(0xFFEDE9FB), AppColors.primary),
    };
    return _Badge(label: label, bg: bg, fg: fg);
  }
}
