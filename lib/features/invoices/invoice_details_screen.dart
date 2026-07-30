import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'domain/entities/invoice.dart';
import 'qc_checkpoint_screen.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark    = Color(0xFF1A1A1A);
const Color _textGrey    = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg      = Color(0xFFF2F2F7);

// ── Screen ────────────────────────────────────────────────────────────────────
class InvoiceDetailsScreen extends StatelessWidget {
  const InvoiceDetailsScreen({super.key, required this.invoice});

  /// Domain entity — replaces former local InvoiceItem reference.
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _DetailsAppBar(invoiceId: invoice.id),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice header card
                    _InvoiceHeaderCard(invoice: invoice),
                    const SizedBox(height: 12),

                    // Customer Information
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _IconRow(
                            icon: Icons.location_on_outlined,
                            text: 'Downtown Construction LLC',
                          ),
                          const SizedBox(height: 8),
                          _IconRow(
                            icon: Icons.person_outline_rounded,
                            text: 'Ahmed Al Mansouri',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Line Items
                    const Text(
                      'Line Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _LineItemsTable(),
                    const SizedBox(height: 16),

                    // Amount Breakdown
                    const Text(
                      'Amount Breakdown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _AmountBreakdownCard(invoice: invoice),
                    const SizedBox(height: 12),

                    // Payment Confirmed
                    _PaymentConfirmedCard(),
                    const SizedBox(height: 12),

                    // Quality Check
                    _WhiteCard(
                      child: Row(
                        children: [
                          const Text(
                            'Quality Check (QC)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _WhiteCard(
                      child: Row(
                        children: [
                          _QcVerifiedBadge(),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => QcCheckpointScreen(
                                  invoiceId: invoice.id,
                                ),
                              ),
                            ),
                            child: const Text(
                              'View Details →',
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
                    const SizedBox(height: 24),

                    // Download Invoice button
                    _GradientButton(
                      icon: Icons.download_rounded,
                      label: 'Download Invoice',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 16),

                    // Share Invoice
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Share Invoice',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
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

// ── App bar ───────────────────────────────────────────────────────────────────
class _DetailsAppBar extends StatelessWidget {
  const _DetailsAppBar({required this.invoiceId});
  final String invoiceId;

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
                'Invoices Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                invoiceId,
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

// ── Invoice header card ───────────────────────────────────────────────────────
class _InvoiceHeaderCard extends StatelessWidget {
  const _InvoiceHeaderCard({required this.invoice});

  /// Domain entity — replaces former local InvoiceItem reference.
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order ID: ${invoice.orderId}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              _StatusBadge(status: invoice.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            invoice.id,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Issue Date',
                      style: TextStyle(fontSize: 12, color: _textGrey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '9 February 2026',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Due Date',
                      style: TextStyle(fontSize: 12, color: _textGrey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '16 February 2026',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _QcVerifiedBadge(),
        ],
      ),
    );
  }
}

// ── Line items table ──────────────────────────────────────────────────────────
class _LineItemsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textGrey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textGrey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textGrey,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: _fieldBorder, height: 1),
          _LineRow(
            item: 'Ready-Mix Concrete\n(Grade 30)',
            qty: '45 m³',
            amount: 'AED 18,900.00',
          ),
          Divider(color: _fieldBorder, height: 1),
          _LineRow(
            item: 'Pump Service\n(42-52m)',
            qty: '1 service',
            amount: 'AED 2,800.00',
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.item, required this.qty, required this.amount});
  final String item;
  final String qty;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _textDark,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              qty,
              style: const TextStyle(fontSize: 14, color: _textDark),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amount breakdown card ─────────────────────────────────────────────────────
class _AmountBreakdownCard extends StatelessWidget {
  const _AmountBreakdownCard({required this.invoice});

  /// Domain entity — replaces former local InvoiceItem reference.
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    const subtotal = 21700.00;
    const vat = 1085.00;

    return _WhiteCard(
      child: Column(
        children: [
          _BreakdownRow(label: 'Subtotal', value: 'AED 21,700.00'),
          const SizedBox(height: 10),
          _BreakdownRow(label: 'VAT (5%)', value: 'AED 1,085.00'),
          const SizedBox(height: 10),
          _DashedDivider(),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              Spacer(),
              Text(
                'AED 22,785.00',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: _textGrey),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _textDark,
          ),
        ),
      ],
    );
  }
}

// ── Payment confirmed card ────────────────────────────────────────────────────
class _PaymentConfirmedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.warning_rounded, size: 20, color: Color(0xFF16A34A)),
              SizedBox(width: 8),
              Text(
                'Payment Confirmed',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.credit_card_rounded, size: 16, color: _textGrey),
              SizedBox(width: 6),
              Text(
                'Paid via Wallet',
                style: TextStyle(fontSize: 14, color: _textDark),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Paid on 9 February 2026',
            style: TextStyle(fontSize: 14, color: _textDark),
          ),
        ],
      ),
    );
  }
}

// ── QC Verified badge ─────────────────────────────────────────────────────────
class _QcVerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 16, color: Color(0xFF16A34A)),
          SizedBox(width: 6),
          Text(
            'QC Verified',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────
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
      InvoiceStatus.draft => ('Draft', const Color(0xFFF1F1F1), _textDark),
      InvoiceStatus.vatInvoiceReady =>
        ('Ready', const Color(0xFFEDE9FB), AppColors.primary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ── Gradient button ───────────────────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
            padding: EdgeInsets.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── White card ────────────────────────────────────────────────────────────────
class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: child,
    );
  }
}

// ── Icon row ──────────────────────────────────────────────────────────────────
class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _textGrey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: _textDark),
        ),
      ],
    );
  }
}

// ── Dashed divider ────────────────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      const dw = 8.0, gap = 5.0;
      final count = (c.maxWidth / (dw + gap)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Padding(
            padding: const EdgeInsets.only(right: gap),
            child: const SizedBox(
              width: dw,
              height: 1,
              child: ColoredBox(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
      );
    });
  }
}
