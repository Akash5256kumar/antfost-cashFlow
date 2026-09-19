import 'package:flutter/material.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';

/// Shown after customer selects "Cash in Advance" payment.
/// Admin needs to verify cash received before order proceeds.
class CashPaymentPendingScreen extends StatelessWidget {
  const CashPaymentPendingScreen({
    super.key,
    this.orderRef = 'AF-2057',
    this.message,
  });

  final String orderRef;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const AppBrandHeader(showBack: false),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFDE68A), width: 2),
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          size: 40,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        'Payment Verification\nPending',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.authScreenTitle(context).copyWith(
                          fontSize: 22,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        message ??
                            'Your order has been received. Since you selected Cash in Advance, our team will verify your payment and confirm the delivery schedule shortly.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Order Reference Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.receipt_long_rounded,
                                size: 22,
                                color: Color(0xFFD97706),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Reference',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  orderRef,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFDE68A)),
                              ),
                              child: const Text(
                                'PENDING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD97706),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Info Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'You will receive a notification once our team confirms the cash payment. Typical confirmation time is within 30 minutes.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Color(0xFF0369A1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Spacer(),

                      // Buttons
                      PrimaryButton(
                        arrow: true,
                        label: 'View My Orders',
                        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.myOrders,
                          (route) => false,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PrimaryButton(
                        variant: PrimaryButtonVariant.outline,
                        label: 'Back to Home',
                        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
