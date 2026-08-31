import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import '../orders/order_confirmed_screen.dart';

/// Ported from the new Figma design's `screens/PaymentConfirmed.tsx`.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    this.orderRef = 'AF-2057',
    this.totalAmount = 29820.00,
    this.paymentMethod = 'Card / Payment Link',
    this.reference = 'ANT-849271',
  });

  final String orderRef;
  final double totalAmount;
  final String paymentMethod;
  final String reference;

  String _fmtAmount(double v) {
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
    final rows = [
      (Icons.receipt_long_rounded, 'Order', orderRef),
      (Icons.credit_card_rounded, 'Payment Method', paymentMethod),
      (Icons.description_outlined, 'Reference', reference),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8), // Space for outer ring
                decoration: BoxDecoration(
                  color: Colors.transparent, // Transparent background
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.04), // Even lighter blue
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_rounded,
                    size: 38,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    'Payment Confirmed',
                    style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.successContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('Confirmed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: AppIllustrationImage(
                asset: AppAssets.artApprovedReceipt,
                height: 150,
                width: 280,
                borderRadius: 0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text('Total Amount', style: AppTextStyles.cardSubtitle(context)),
                  Text(_fmtAmount(totalAmount), style: AppTextStyles.amountLarge(context).copyWith(fontSize: 32)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: List.generate(rows.length, (i) {
                  final r = rows[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: i < rows.length - 1
                          ? const Border(bottom: BorderSide(color: AppColors.cardBorder))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(r.$1, size: 20, color: const Color(0xFF8B5CF6)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.$2, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const SizedBox(height: 2),
                              Text(r.$3, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 15, color: Color(0xFF8B5CF6)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'ANTFAST is preparing your order proposal.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8B5CF6)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              arrow: true,
              label: 'View Order Status',
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => OrderConfirmedScreen(orderId: orderRef),
                ),
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              icon: const Icon(Icons.download_rounded, size: 18, color: AppColors.primary),
              label: 'Download Receipt',
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                child: Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 10), // Extra space to prevent bottom nav overlap
          ],
        ),
      ),
    );
  }
}
