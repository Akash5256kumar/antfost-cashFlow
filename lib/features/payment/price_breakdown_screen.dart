import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import 'payment_screen.dart';

/// Ported from the new Figma design's `screens/PriceBreakdown.tsx`.
class PriceBreakdownScreen extends StatefulWidget {
  const PriceBreakdownScreen({
    super.key,
    this.projectName = 'Marina Tower',
    this.mixCode = 'C25/30',
    this.quantity = 25,
    this.deliveryDate = '10 Feb',
    this.pricePerM3 = 180.0,
    this.deliveryFee = 350.0,
    this.serviceCharge = 120.0,
    this.paymentMethodCharge = 25.0,
    this.vatRate = 0.05,
    this.walletApplied = 10000.0,
    this.totalAmount,
  });

  final String projectName;
  final String mixCode;
  final int quantity;
  final String deliveryDate;
  final double pricePerM3;
  final double deliveryFee;
  final double serviceCharge;
  final double paymentMethodCharge;
  final double vatRate;
  final double walletApplied;
  final double? totalAmount;

  double get _concreteCost => quantity * pricePerM3;
  double get _subtotal =>
      _concreteCost + deliveryFee + serviceCharge + paymentMethodCharge;
  double get _vat => _subtotal * vatRate;
  double get _orderTotal => totalAmount ?? (_subtotal + _vat);
  double get _remaining => _orderTotal - walletApplied;

  @override
  State<PriceBreakdownScreen> createState() => _PriceBreakdownScreenState();
}

class _PriceBreakdownScreenState extends State<PriceBreakdownScreen> {
  bool _reviewed = false;

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
    final items = [
      ('Concrete', widget._concreteCost),
      ('Concrete Pump', widget.deliveryFee),
      ('Technician & 6 Cube Moulds', widget.serviceCharge),
      ('Payment Method Charge', widget.paymentMethodCharge),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Image in background
                Positioned(
                  top: -20,
                  right: -30,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      AppAssets.artHeroTruck,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Content on left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Breakdown',
                      style: AppTextStyles.authScreenTitle(
                        context,
                      ).copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.credit_card_rounded,
                            size: 14,
                            color: Color(0xFF8B5CF6),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Card / Payment Link',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      '${widget.projectName} · ${widget.quantity} m³ · ${widget.mixCode}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ...items.map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.$1, style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                          ),
                          Text(
                            _fmt(item.$2),
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text('Subtotal', style: AppTextStyles.cardSubtitle(context))),
                        Text(
                          _fmt(widget._subtotal),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(child: Text('VAT ${(widget.vatRate * 100).toStringAsFixed(0)}%', style: AppTextStyles.cardSubtitle(context))),
                        Text(
                          _fmt(widget._vat),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F3FF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Order Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                            ),
                            Text(
                              _fmt(widget._orderTotal),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        if (widget.walletApplied > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Wallet Applied', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
                              ),
                              Text(
                                '-${_fmt(widget.walletApplied)}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Remaining Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                            ),
                            Text(
                              _fmt(widget._remaining),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Info Row
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Price reflects the selected payment method.',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => _reviewed = !_reviewed),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _reviewed ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _reviewed ? AppColors.primary : const Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                      ),
                      child: _reviewed
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'I have reviewed this amount',
                      style: TextStyle(fontSize: 13, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              arrow: true,
              label: 'Accept Price',
              onPressed: _reviewed
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            totalAmount: widget._orderTotal,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              label: 'Change Payment Method',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
          ],
        ),
      ),
    );
  }
}
