import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_schedule_screen.dart';
import 'order_step_widgets.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderQuantityScreen extends StatefulWidget {
  const NewCashOrderQuantityScreen({super.key, required this.mixCode});
  final MixCodeItem mixCode;

  @override
  State<NewCashOrderQuantityScreen> createState() =>
      _NewCashOrderQuantityScreenState();
}

class _NewCashOrderQuantityScreenState
    extends State<NewCashOrderQuantityScreen> {
  int _quantity = 25;

  static const List<int> _presets = [10, 25, 50, 100];

  double get _total => widget.mixCode.pricePerM3 * _quantity * 1.05;
  bool get _needsReview => _quantity > 100;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  String _formatTotal(double amount) {
    final s = amount.toStringAsFixed(1);
    final parts = s.split('.');
    final buf = StringBuffer();
    final digits = parts[0];
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return 'AED $buf.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OrderStepAppBar(subtitle: 'Quantity'),
            const OrderStepperSection(currentStep: 2),

            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section heading
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kOrderTextDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Enter the volume you need in cubic meters',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kOrderTextGrey,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── +/- stepper card ──────────────────────────
                      _QuantityStepperCard(
                        quantity: _quantity,
                        onDecrement: _decrement,
                        onIncrement: _increment,
                      ),
                      const SizedBox(height: 16),

                      // ── Preset chips ──────────────────────────────
                      Row(
                        children: _presets
                            .map(
                              (v) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: v == _presets.last ? 0 : 8,
                                  ),
                                  child: _PresetChip(
                                    value: v,
                                    isSelected: _quantity == v,
                                    onTap: () =>
                                        setState(() => _quantity = v),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      // ── Manual review warning ─────────────────────
                      if (_needsReview) ...[
                        const SizedBox(height: 16),
                        const _ManualReviewBanner(),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── Estimated total bar ───────────────────────────────────
            _EstimatedTotalBar(
              formula:
                  '${widget.mixCode.pricePerM3} × $_quantity m³ + 5% VAT',
              total: _formatTotal(_total),
            ),

            OrderStepBottomBar(
              onContinue: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NewCashOrderScheduleScreen(
                    mixCode: widget.mixCode,
                    quantity: _quantity,
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

// ── Quantity stepper card ─────────────────────────────────────────────────────

class _QuantityStepperCard extends StatelessWidget {
  const _QuantityStepperCard({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kOrderFieldBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Minus
          _CircleButton(label: '−', onTap: onDecrement),

          // Quantity display
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: kOrderTextDark,
                    height: 1.1,
                  ),
                ),
                const Text(
                  'cubic meters',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: kOrderTextGrey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Plus
          _CircleButton(label: '+', onTap: onIncrement),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F1F1),
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: kOrderTextDark,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ── Preset chip ───────────────────────────────────────────────────────────────

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          '$value m³',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : kOrderTextDark,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

// ── Manual review banner ──────────────────────────────────────────────────────

class _ManualReviewBanner extends StatelessWidget {
  const _ManualReviewBanner();

  static const Color _warningColor = Color(0xFFFF5CA8);
  static const Color _bgColor      = Color(0xFFFFF0F5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: _warningColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Manual Review Required',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _warningColor,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Orders above 100 m³ require manual feasibility review. Our team will contact you.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF444444),
                    height: 1.45,
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

// ── Estimated total bar ───────────────────────────────────────────────────────

class _EstimatedTotalBar extends StatelessWidget {
  const _EstimatedTotalBar({
    required this.formula,
    required this.total,
  });

  final String formula;
  final String total;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DashedDivider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formula,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kOrderTextGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  total,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kOrderTextDark,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
