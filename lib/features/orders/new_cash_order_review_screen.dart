import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../payment/payment_screen.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'order_step_widgets.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderReviewScreen extends StatefulWidget {
  const NewCashOrderReviewScreen({
    super.key,
    required this.mixCode,
    required this.quantity,
    required this.structureRef,
    required this.technicianRequired,
    required this.temperatureControl,
    this.temperature,
    required this.pumpRequired,
    this.pumpName,
    required this.cubeMould,
    required this.numMoulds,
  });

  final MixCodeItem mixCode;
  final int quantity;
  final String structureRef;
  final bool technicianRequired;
  final bool temperatureControl;
  final int? temperature;
  final bool pumpRequired;
  final String? pumpName;
  final bool cubeMould;
  final int numMoulds;

  @override
  State<NewCashOrderReviewScreen> createState() =>
      _NewCashOrderReviewScreenState();
}

class _NewCashOrderReviewScreenState extends State<NewCashOrderReviewScreen> {
  bool _agreedToTerms = false;  
  final _specialRequestsController = TextEditingController();

  double get _subtotal => widget.mixCode.pricePerM3 * widget.quantity.toDouble();
  double get _vat => _subtotal * 0.05;
  double get _total => _subtotal + _vat;

  String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final buf = StringBuffer();
    final d = parts[0];
    for (var i = 0; i < d.length; i++) {
      if (i > 0 && (d.length - i) % 3 == 0) buf.write(',');
      buf.write(d[i]);
    }
    return 'AED $buf.${parts[1]}';
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pumpFee = widget.pumpRequired ? 600.0 : 0.0;

    return Scaffold(
      backgroundColor: kOrderBodyBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _ReviewAppBar(),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Review Order',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Confirm your order details before payment',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kOrderTextGrey,
                        height: 1.43,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Order summary card ────────────────────────────
                    _OrderSummaryCard(
                      projectName: 'Downtown Project',
                      productLabel:
                          '${widget.mixCode.code} - ${widget.mixCode.type} (${widget.quantity} M³)',
                      deliveryDate: '10 Feb 2026',
                      timeSlot: '6 AM - 10 AM (±4 hrs)',
                      trips: '3 trips • 45 min gap',
                    ),
                    const SizedBox(height: 16),

                    // ── Additional requirements ───────────────────────
                    if (widget.technicianRequired ||
                        widget.temperatureControl ||
                        widget.pumpRequired) ...[
                      _AdditionalRequirementsCard(
                        technicianRequired: widget.technicianRequired,
                        temperature: widget.temperature,
                        pumpName: widget.pumpName,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Special requests ──────────────────────────────
                    _SpecialRequestsCard(
                      controller: _specialRequestsController,
                    ),
                    const SizedBox(height: 16),

                    // ── Price breakdown ───────────────────────────────
                    _PriceBreakdownCard(
                      mixCode: widget.mixCode.code,
                      quantity: widget.quantity,
                      subtotal: _subtotal,
                      pumpFee: pumpFee,
                      vat: _vat,
                      total: _total + pumpFee,
                    ),
                    const SizedBox(height: 16),

                    // ── Terms checkbox ────────────────────────────────
                    _TermsRow(
                      agreed: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom bar
            _ReviewBottomBar(
              onProceed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PaymentScreen(totalAmount: _total + pumpFee),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Review app bar ────────────────────────────────────────────────────────────

class _ReviewAppBar extends StatelessWidget {
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
            children: const [
              Text(
                'New Cash Order',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Review',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: kOrderTextGrey,
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

// ── Order summary card ────────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.projectName,
    required this.productLabel,
    required this.deliveryDate,
    required this.timeSlot,
    required this.trips,
  });

  final String projectName;
  final String productLabel;
  final String deliveryDate;
  final String timeSlot;
  final String trips;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.location_on_outlined,
            iconBg: const Color(0xFFEDE9FB),
            iconColor: AppColors.primary,
            label: 'Delivery Location',
            value: projectName,
          ),
          const _DashedRow(),
          _SummaryRow(
            icon: Icons.view_in_ar_outlined,
            iconBg: const Color(0xFFEDE9FB),
            iconColor: AppColors.primary,
            label: 'Product',
            value: productLabel,
          ),
          const _DashedRow(),
          _SummaryRow(
            icon: Icons.calendar_month_outlined,
            iconBg: const Color(0xFFFFF8D6),
            iconColor: const Color(0xFFFF8A00),
            label: 'Delivery Schedule',
            value: '$deliveryDate\n$timeSlot\n$trips',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: kOrderTextGrey,
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kOrderTextDark,
                    height: 1.4,
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

class _DashedRow extends StatelessWidget {
  const _DashedRow();

  @override
  Widget build(BuildContext context) {
    return const DashedDivider(color: Color(0xFFE0E0E0));
  }
}

// ── Additional requirements card ──────────────────────────────────────────────

class _AdditionalRequirementsCard extends StatelessWidget {
  const _AdditionalRequirementsCard({
    required this.technicianRequired,
    this.temperature,
    this.pumpName,
  });

  final bool technicianRequired;
  final int? temperature;
  final String? pumpName;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Requirements',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kOrderTextDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          if (technicianRequired) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Technician',
                  style: TextStyle(
                    fontSize: 14,
                    color: kOrderTextGrey,
                    height: 1.3,
                  ),
                ),
                const Text(
                  'Required',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
          if (temperature != null) ...[
            const DashedDivider(color: Color(0xFFE0E0E0)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Temperature',
                  style: TextStyle(fontSize: 14, color: kOrderTextGrey),
                ),
                Text(
                  '${temperature}°C',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kOrderTextDark,
                  ),
                ),
              ],
            ),
          ],
          if (pumpName != null) ...[
            const SizedBox(height: 10),
            const DashedDivider(color: Color(0xFFE0E0E0)),
            const SizedBox(height: 10),
            const Text(
              'Pump Configuration',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kOrderTextDark,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Pump (42-52)',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Special requests card ─────────────────────────────────────────────────────

class _SpecialRequestsCard extends StatelessWidget {
  const _SpecialRequestsCard({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Special Requests (Optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kOrderTextDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(
              fontSize: 14,
              color: kOrderTextDark,
              height: 1.5,
            ),
            decoration: const InputDecoration(
              hintText: 'Any special instructions or requirements...',
              hintStyle: TextStyle(fontSize: 14, color: kOrderTextGrey),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Price breakdown card ──────────────────────────────────────────────────────

class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard({
    required this.mixCode,
    required this.quantity,
    required this.subtotal,
    required this.pumpFee,
    required this.vat,
    required this.total,
  });

  final String mixCode;
  final int quantity;
  final double subtotal;
  final double pumpFee;
  final double vat;
  final double total;

  String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final buf = StringBuffer();
    final d = parts[0];
    for (var i = 0; i < d.length; i++) {
      if (i > 0 && (d.length - i) % 3 == 0) buf.write(',');
      buf.write(d[i]);
    }
    return 'AED $buf.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kOrderTextDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          _PriceRow(
            label: 'Subtotal ($quantity m³ × AED ${subtotal ~/ quantity}.00)',
            value: _fmt(subtotal),
            labelColor: kOrderTextGrey,
          ),
          if (pumpFee > 0) ...[
            const SizedBox(height: 10),
            _PriceRow(
              label: 'Pump Fee',
              value: _fmt(pumpFee),
              labelColor: kOrderTextGrey,
            ),
          ],
          const SizedBox(height: 10),
          _PriceRow(
            label: 'VAT (5%)',
            value: _fmt(vat),
            labelColor: kOrderTextGrey,
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE8E8E8), height: 1),
          const SizedBox(height: 12),
          _PriceRow(
            label: 'Total',
            value: _fmt(total),
            labelBold: true,
            valueColor: AppColors.primary,
            valueBold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.labelColor = kOrderTextDark,
    this.labelBold = false,
    this.valueColor = kOrderTextDark,
    this.valueBold = false,
  });

  final String label;
  final String value;
  final Color labelColor;
  final bool labelBold;
  final Color valueColor;
  final bool valueBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: labelBold ? FontWeight.w600 : FontWeight.w400,
            color: labelColor,
            height: 1.3,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// ── Terms row ─────────────────────────────────────────────────────────────────

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.agreed, required this.onChanged});
  final bool agreed;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: agreed,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            side: const BorderSide(color: Color(0xFFD0CDE8), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "By proceeding, you agree to ANTFAST's Terms of Service including non-refundable policy after batching, site readiness responsibility, waiting time charges, and ±5% quantity tolerance.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: kOrderTextGrey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Review bottom bar ─────────────────────────────────────────────────────────

class _ReviewBottomBar extends StatelessWidget {
  const _ReviewBottomBar({required this.onProceed});
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: _GradientButton(label: 'Proceed to Payment', onPressed: onProceed),
      ),
    );
  }
}

// ── White card helper ─────────────────────────────────────────────────────────

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
        border: Border.all(color: kOrderFieldBorder),
      ),
      child: child,
    );
  }
}

// ── Gradient button ───────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onPressed, this.icon});
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
              AppColors.primaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
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
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
