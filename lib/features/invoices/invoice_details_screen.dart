import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import 'domain/entities/invoice.dart';
import 'qc_checkpoint_screen.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = AppColors.textPrimary;
const Color _textGrey = AppColors.textSecondary;
const Color _fieldBorder = AppColors.cardBorder;
const Color _bodyBg = AppColors.background;

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
                padding: EdgeInsets.fromLTRB(
                  context.scaled(16),
                  context.scaled(16),
                  context.scaled(16),
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice header card
                    _InvoiceHeaderCard(invoice: invoice),
                    SizedBox(height: context.scaledV(12)),

                    // Customer Information
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize: context.scaled(16),
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: context.scaledV(12)),
                          _IconRow(
                            icon: Icons.location_on_outlined,
                            text: 'Downtown Construction LLC',
                          ),
                          SizedBox(height: context.scaledV(8)),
                          _IconRow(
                            icon: Icons.person_outline_rounded,
                            text: 'Ahmed Al Mansouri',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),

                    // Line Items
                    Text(
                      'Line Items',
                      style: TextStyle(
                        fontSize: context.scaled(16),
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.scaledV(10)),
                    _LineItemsTable(),
                    SizedBox(height: context.scaledV(16)),

                    // Amount Breakdown
                    Text(
                      'Amount Breakdown',
                      style: TextStyle(
                        fontSize: context.scaled(16),
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.scaledV(10)),
                    _AmountBreakdownCard(invoice: invoice),
                    SizedBox(height: context.scaledV(12)),

                    // Payment Confirmed
                    _PaymentConfirmedCard(),
                    SizedBox(height: context.scaledV(12)),

                    // Quality Check
                    _WhiteCard(
                      child: Row(
                        children: [
                          Text(
                            'Quality Check (QC)',
                            style: TextStyle(
                              fontSize: context.scaled(15),
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(8)),
                    _WhiteCard(
                      child: Row(
                        children: [
                          _QcVerifiedBadge(),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    QcCheckpointScreen(invoiceId: invoice.id),
                              ),
                            ),
                            child: Text(
                              'View Details →',
                              style: TextStyle(
                                fontSize: context.scaled(14),
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(24)),

                    // Download Invoice button
                    _GradientButton(
                      icon: Icons.download_rounded,
                      label: 'Download Invoice',
                      onPressed: () {},
                    ),
                    SizedBox(height: context.scaledV(16)),

                    // Share Invoice
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Share Invoice',
                          style: TextStyle(
                            fontSize: context.scaled(15),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaledV(32)),
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
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaled(8),
        context.scaled(16),
        context.scaled(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.scaled(44),
            height: context.scaled(44),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back_rounded, size: context.scaled(24)),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          SizedBox(width: context.scaled(4)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Invoices Details',
                style: TextStyle(
                  fontSize: context.scaled(20),
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: context.scaledV(2)),
              Text(
                invoiceId,
                style: TextStyle(
                  fontSize: context.scaled(13),
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
                style: TextStyle(
                  fontSize: context.scaled(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              _StatusBadge(status: invoice.status),
            ],
          ),
          SizedBox(height: context.scaledV(4)),
          Text(
            invoice.id,
            style: TextStyle(
              fontSize: context.scaled(18),
              fontWeight: FontWeight.w700,
              color: _textDark,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.scaledV(14)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Issue Date',
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        color: _textGrey,
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      '9 February 2026',
                      style: TextStyle(
                        fontSize: context.scaled(15),
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
                  children: [
                    Text(
                      'Due Date',
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        color: _textGrey,
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      '16 February 2026',
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaledV(14)),
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
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaled(16),
              vertical: context.scaled(10),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(context.scaled(16)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontSize: context.scaled(13),
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
                      fontSize: context.scaled(13),
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
                      fontSize: context.scaled(13),
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
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(16),
        vertical: context.scaled(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item,
              style: TextStyle(
                fontSize: context.scaled(14),
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
              style: TextStyle(fontSize: context.scaled(14), color: _textDark),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: context.scaled(14),
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
          SizedBox(height: context.scaledV(10)),
          _BreakdownRow(label: 'VAT (5%)', value: 'AED 1,085.00'),
          SizedBox(height: context.scaledV(10)),
          _DashedDivider(),
          SizedBox(height: context.scaledV(10)),
          Row(
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: context.scaled(15),
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const Spacer(),
              Text(
                'AED 22,785.00',
                style: TextStyle(
                  fontSize: context.scaled(18),
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
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: context.scaled(14), color: _textGrey),
          ),
        ),
        SizedBox(width: context.scaled(8)),
        Text(
          value,
          style: TextStyle(
            fontSize: context.scaled(14),
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
      padding: EdgeInsets.all(context.scaled(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                size: context.scaled(20),
                color: const Color(0xFF16A34A),
              ),
              SizedBox(width: context.scaled(8)),
              Text(
                'Payment Confirmed',
                style: TextStyle(
                  fontSize: context.scaled(15),
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaledV(8)),
          Row(
            children: [
              Icon(
                Icons.credit_card_rounded,
                size: context.scaled(16),
                color: _textGrey,
              ),
              SizedBox(width: context.scaled(6)),
              Text(
                'Paid via Wallet',
                style: TextStyle(
                  fontSize: context.scaled(14),
                  color: _textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaledV(4)),
          Text(
            'Paid on 9 February 2026',
            style: TextStyle(fontSize: context.scaled(14), color: _textDark),
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
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(12),
        vertical: context.scaled(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(context.scaled(20)),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: context.scaled(16),
            color: const Color(0xFF16A34A),
          ),
          SizedBox(width: context.scaled(6)),
          Text(
            'QC Verified',
            style: TextStyle(
              fontSize: context.scaled(13),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF16A34A),
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
      InvoiceStatus.paid => (
        'Paid',
        const Color(0xFFDCFCE7),
        const Color(0xFF16A34A),
      ),
      InvoiceStatus.sent => (
        'Sent',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
      ),
      InvoiceStatus.draft => ('Draft', const Color(0xFFF1F1F1), _textDark),
      InvoiceStatus.vatInvoiceReady => (
        'Ready',
        AppColors.primaryContainer,
        AppColors.primary,
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(12),
        vertical: context.scaled(4),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.scaled(20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.scaled(12),
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
      height: context.scaled(58),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(context.scaled(18)),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.scaled(18)),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: context.scaled(20), color: Colors.white),
                SizedBox(width: context.scaled(8)),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: context.scaled(16),
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
      padding: EdgeInsets.all(context.scaled(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
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
        Icon(icon, size: context.scaled(18), color: _textGrey),
        SizedBox(width: context.scaled(8)),
        Text(
          text,
          style: TextStyle(fontSize: context.scaled(14), color: _textDark),
        ),
      ],
    );
  }
}

// ── Dashed divider ────────────────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
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
      },
    );
  }
}
