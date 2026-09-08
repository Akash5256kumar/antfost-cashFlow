import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../orders/agreement_summary_screen.dart';
import 'payment_success_screen.dart';

class _TermsSection {
  const _TermsSection(this.icon, this.title, this.desc);
  final IconData icon;
  final String title;
  final String desc;
}

const _sections = [
  _TermsSection(
    Icons.receipt_long_rounded,
    'Order Request & Pricing',
    'Orders are confirmed upon acceptance of the final price proposal. Prices are subject to change based on market conditions.',
  ),
  _TermsSection(
    Icons.account_balance_wallet_rounded,
    'Payment',
    'Payment must be completed within 48 hours of price acceptance. Late payments may result in order cancellation.',
  ),
  _TermsSection(
    Icons.apartment_rounded,
    'Site Readiness',
    'The customer is responsible for ensuring site access and readiness at the scheduled delivery time.',
  ),
  _TermsSection(
    Icons.local_shipping_rounded,
    'Delivery & Delays',
    'ANTFAST will notify customers of any delays. Waiting charges apply after 30 minutes of idle time on site.',
  ),
  _TermsSection(
    Icons.refresh_rounded,
    'Cancellation & Refunds',
    'Cancellations made within 24 hours of delivery are subject to a 10% cancellation fee. Refunds are processed within 5-7 working days.',
  ),
];

/// Ported from the new Figma design's `screens/TermsConditions.tsx` — a
/// general order T&Cs screen shown after price acceptance. For orders >100 m³,
/// navigates to `AgreementSummaryScreen` for feasibility agreement before payment.
class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({
    super.key,
    this.orderRef = 'AF-2057',
    this.totalAmount = 29820.00,
    this.quantity,
    this.nextRoute,
  });

  final String orderRef;
  final double totalAmount;
  final int? quantity;
  final String? nextRoute;

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final amount = 'AED ${widget.totalAmount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBrandHeader(
        showBack: true,
        onBellTap: () {}, // Add your notifications route here if needed
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Terms & Conditions',
              style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 26),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF), // slightly more visible purple
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.assignment_outlined, size: 18, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.orderRef} · $amount',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: List.generate(_sections.length, (i) {
                  final s = _sections[i];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: i < _sections.length - 1
                          ? const Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))
                          : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(s.icon, size: 20, color: const Color(0xFF8B5CF6)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                              const SizedBox(height: 4),
                              Text(s.desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => setState(() => _agreed = !_agreed),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _agreed ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _agreed ? AppColors.primary : const Color(0xFFCBD5E1), width: 1.5),
                    ),
                    child: _agreed ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'I have read and agree to the ANTFAST Terms & Conditions.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Terms version 4.2 · 04 Aug 2026', 
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              arrow: true,
              label: ((widget.quantity ?? PaymentSuccessScreen.currentOrderQuantity) > 100)
                  ? 'Review Feasibility Agreement'
                  : 'Continue to Payment',
              onPressed: _agreed
                  ? () {
                      final qty = widget.quantity ?? PaymentSuccessScreen.currentOrderQuantity;
                      if (qty > 100) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AgreementSummaryScreen(
                              approvedVolume: qty,
                              buttonText: 'Accept Agreement & Continue',
                              onAccept: () {
                                Navigator.of(context).pushNamed(
                                  widget.nextRoute ?? AppRoutes.completePayment,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                          widget.nextRoute ?? AppRoutes.completePayment,
                        );
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
          ],
        ),
      ),
    );
  }
}
