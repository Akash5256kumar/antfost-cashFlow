import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import 'payment_screen.dart';
import '../../app/di/injection.dart';
import '../../core/services/order_api_service.dart';

/// Pixel-perfect implementation matching the Figma Price Breakdown design.
class PriceBreakdownScreen extends StatefulWidget {
  const PriceBreakdownScreen({
    super.key,
    this.projectName = 'Palm Jumeirah Villa',
    this.mixCode = 'C30/37',
    this.quantity = 120,
    this.deliveryDate = '10 Feb',
    this.pricePerM3 = 210.0,
    this.deliveryFee = 2400.0,
    this.serviceCharge = 600.0,
    this.paymentMethodCharge = 200.0,
    this.vatRate = 0.05,
    this.walletApplied = 10000.0,
    this.totalAmount,
    this.nextRoute,
    this.orderId,
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
  final String? nextRoute;
  final String? orderId;

  double get _concreteCost => quantity * pricePerM3;
  double get _subtotal =>
      _concreteCost + deliveryFee + serviceCharge + paymentMethodCharge;
  double get _vat => _subtotal * vatRate;
  double get _orderTotal => totalAmount ?? (_subtotal + _vat);

  @override
  State<PriceBreakdownScreen> createState() => _PriceBreakdownScreenState();
}

class _PriceBreakdownScreenState extends State<PriceBreakdownScreen> {
  bool _reviewed = false;
  Map<String, dynamic>? _serverPrice;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) _loadPrice();
  }

  Future<void> _loadPrice() async {
    try {
      final response = await sl<OrderApiService>().priceBreakdown(
        widget.orderId!,
      );
      if (mounted) setState(() => _serverPrice = response);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

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
    final price = _serverPrice?['priceBreakdown'] as Map?;
    final serverTotal = (price?['total'] as num?)?.toDouble();
    final items = [
      (
        'Concrete',
        (price?['concrete'] as num?)?.toDouble() ?? widget._concreteCost,
      ),
      (
        'Concrete Pump',
        (price?['concretePump'] as num?)?.toDouble() ?? widget.deliveryFee,
      ),
      (
        'Technician & 6 Cube Moulds',
        (price?['technicianAnd6CubeMoulds'] as num?)?.toDouble() ??
            widget.serviceCharge,
      ),
      (
        'Payment Method Charge',
        (price?['paymentMethodCharge'] as num?)?.toDouble() ??
            widget.paymentMethodCharge,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const AppBrandHeader(showBack: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 4),
                    // Header with title, badge and seamlessly blended illustration
                    SizedBox(
                      height: 145,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Batching plant, crane & mixer truck artwork (seamlessly blended PNG)
                          Positioned(
                            top: 0,
                            right: -15,
                            bottom: 0,
                            child: Image.asset(
                              AppAssets.artBreakdownHero,
                              height: 145,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Content on left
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price Breakdown',
                                style: AppTextStyles.authScreenTitle(context)
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F172A),
                                      letterSpacing: -0.3,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.credit_card_outlined,
                                      size: 13,
                                      color: Color(0xFF6366F1),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Card / Payment Link',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.52,
                                ),
                                child: Text(
                                  '${widget.projectName} · ${widget.quantity} m³ · ${widget.mixCode}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quotation Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ...items.map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 11,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.$1,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _fmt(item.$2),
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                Text(
                                  _fmt(
                                    (price?['subtotal'] as num?)?.toDouble() ??
                                        widget._subtotal,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'VAT ${(widget.vatRate * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                Text(
                                  _fmt(
                                    (price?['vat'] as num?)?.toDouble() ??
                                        widget._vat,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F3FF),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Text(
                                  _fmt(serverTotal ?? widget._orderTotal),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF4F46E5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Info Row
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Price reflects the selected payment method.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Spacer pushes the review box and buttons to the bottom
                    const Spacer(),
                    const SizedBox(height: 12),

                    // Review Checkbox Card (Exact match to screenshot)
                    GestureDetector(
                      onTap: () => setState(() => _reviewed = !_reviewed),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                color: _reviewed
                                    ? const Color(0xFF4F46E5)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _reviewed
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                              ),
                              child: _reviewed
                                  ? const Icon(
                                      Icons.check,
                                      size: 13,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'I have reviewed this amount',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF334155),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Proceed to Payment Method Button
                    PrimaryButton(
                      arrow: true,
                      label: 'Proceed to Payment',
                      onPressed: _reviewed
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(
                                    orderId: widget.orderId,
                                    totalAmount:
                                        serverTotal ?? widget._orderTotal,
                                    quantity: widget.quantity,
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                    const SizedBox(height: 8),

                    // Back to Order Review Button
                    PrimaryButton(
                      variant: PrimaryButtonVariant.outline,
                      label: 'Back to Order Review',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
