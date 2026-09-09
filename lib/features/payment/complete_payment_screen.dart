import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_outline_button.dart';

class CompletePaymentScreen extends StatefulWidget {
  const CompletePaymentScreen({super.key, this.totalAmount = 29820.00});

  final double totalAmount;

  @override
  State<CompletePaymentScreen> createState() => _CompletePaymentScreenState();
}

class _CompletePaymentScreenState extends State<CompletePaymentScreen> {
  int _tab = 0; // 0 = card, 1 = link

  @override
  Widget build(BuildContext context) {
    final amount =
        'AED ${widget.totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppBrandHeader(showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.scaled(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.scaledV(16)),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Image in background (right aligned)
                        Positioned(
                          top: 0,
                          right: -context.scaled(
                            30,
                          ), // Push slightly out of bounds
                          child: Opacity(
                            opacity: 0.9,
                            child: Image.asset(
                              AppAssets.artPaymentCard,
                              height: context.scaled(180),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Content on left
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Payment',
                              style: TextStyle(
                                fontSize: context.scaled(22),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E1B4B),
                              ),
                            ),
                            SizedBox(height: context.scaledV(12)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaled(12),
                                vertical: context.scaledV(6),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(
                                  context.scaled(16),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.credit_card_outlined,
                                    size: context.scaled(14),
                                    color: const Color(0xFF8B5CF6),
                                  ),
                                  SizedBox(width: context.scaled(6)),
                                  Text(
                                    'Card / Payment Link',
                                    style: TextStyle(
                                      fontSize: context.scaled(12),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: context.scaledV(24)),

                            Text(
                              'Amount to be paid',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: context.scaledV(4)),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'AED ',
                                    style: TextStyle(
                                      fontSize: context.scaled(16),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E1B4B),
                                    ),
                                  ),
                                  TextSpan(
                                    text: amount.replaceAll('AED ', ''),
                                    style: TextStyle(
                                      fontSize: context.scaled(24),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E1B4B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.scaledV(24)),

                    // Segmented Control
                    Container(
                      padding: EdgeInsets.all(context.scaled(4)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(context.scaled(12)),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              label: 'Pay by Card',
                              active: _tab == 0,
                              onTap: () => setState(() => _tab = 0),
                            ),
                          ),
                          Expanded(
                            child: _TabButton(
                              label: 'Send Payment Link',
                              active: _tab == 1,
                              onTap: () => setState(() => _tab = 1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.scaledV(24)),

                    if (_tab == 0) ...[
                      // Card Form
                      _CustomTextField(hint: 'Cardholder Name'),
                      SizedBox(height: context.scaledV(16)),
                      _CustomTextField(
                        hint: 'Card Number',
                        suffixIcon: Icons.credit_card_outlined,
                      ),
                      SizedBox(height: context.scaledV(16)),
                      Row(
                        children: [
                          Expanded(child: _CustomTextField(hint: 'MM/YY')),
                          SizedBox(width: context.scaled(16)),
                          Expanded(
                            child: _CustomTextField(
                              hint: 'CVV',
                              suffixIcon: Icons.info_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.scaledV(24)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.gpp_good_outlined,
                            size: context.scaled(14),
                            color: const Color(0xFF64748B),
                          ),
                          SizedBox(width: context.scaled(6)),
                          Text(
                            'Encrypted payment • 3D Secure supported',
                            style: TextStyle(
                              fontSize: context.scaled(11),
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: context.scaledV(32)),

                    // Bottom buttons
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        context.scaled(16),
                        0,
                        MediaQuery.paddingOf(context).bottom +
                            context.scaled(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: 'Pay $amount',
                            icon: Icon(
                              Icons.lock_outline_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.paymentSuccess);
                            },
                          ),
                          SizedBox(height: context.scaledV(12)),
                          AppOutlineButton(
                            label: 'Change Method',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.scaledV(10)),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(context.scaled(8)),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(13),
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? suffixIcon;

  const _CustomTextField({required this.hint, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(12)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(16),
        vertical: context.scaledV(4),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: context.scaled(13),
            color: const Color(0xFF94A3B8),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: const Color(0xFF94A3B8),
                  size: context.scaled(20),
                )
              : null,
        ),
        style: TextStyle(
          fontSize: context.scaled(13),
          color: const Color(0xFF1E1B4B),
        ),
      ),
    );
  }
}
