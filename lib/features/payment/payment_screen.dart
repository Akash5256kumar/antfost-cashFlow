import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_outline_button.dart';

enum _PayMethodId { wallet, card, bank, cash }

class _PayMethodSpec {
  const _PayMethodSpec(this.id, this.label, this.desc, this.imageAsset);
  final _PayMethodId id;
  final String label;
  final String? desc;
  final String imageAsset;
}

const _methods = [
  _PayMethodSpec(
    _PayMethodId.wallet,
    'Wallet',
    'AED 24,850 available',
    AppAssets.artWalletMini,
  ),
  _PayMethodSpec(
    _PayMethodId.card,
    'Card / Payment Link',
    null,
    AppAssets.artCardMini,
  ),
  _PayMethodSpec(
    _PayMethodId.bank,
    'Bank Transfer',
    null,
    AppAssets.artBankMini,
  ),
  _PayMethodSpec(
    _PayMethodId.cash,
    'Cash in Advance',
    null,
    AppAssets.artCashMini,
  ),
];

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.totalAmount,
    this.orderRef = 'AF-2057',
    this.quantity = 120,
  });

  final double totalAmount;
  final String orderRef;
  final int quantity;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PayMethodId _selected = _PayMethodId.card;

  void _continue() {
    switch (_selected) {
      case _PayMethodId.card:
        Navigator.of(context).pushNamed(AppRoutes.completePayment);
      case _PayMethodId.bank:
        Navigator.of(context).pushNamed(AppRoutes.uploadPaymentProof);
      case _PayMethodId.wallet:
        Navigator.of(context).pushNamed(AppRoutes.splitWalletPayment);
      case _PayMethodId.cash:
        Navigator.of(context).pushNamed(AppRoutes.priceBreakdown);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(height: context.scaledV(24)),
                    Text(
                      'Choose Payment Method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(20),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1B4B),
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaled(12),
                          vertical: context.scaledV(6),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(context.scaled(16)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: context.scaled(14),
                              color: const Color(0xFF8B5CF6),
                            ),
                            SizedBox(width: context.scaled(6)),
                            Text(
                              '${widget.orderRef} • ${widget.quantity} m³',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaledV(32)),
                    
                    ..._methods.map((m) {
                      final isSelected = m.id == _selected;
                      return Padding(
                        padding: EdgeInsets.only(bottom: context.scaledV(16)),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = m.id),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaled(16),
                              vertical: context.scaledV(12),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF5F7FF) : Colors.white,
                              borderRadius: BorderRadius.circular(context.scaled(16)),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  m.imageAsset,
                                  width: context.scaled(64),
                                  height: context.scaled(64),
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: context.scaled(16)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.label,
                                        style: TextStyle(
                                          fontSize: context.scaled(15),
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1F2533),
                                        ),
                                      ),
                                      if (m.desc != null) ...[
                                        SizedBox(height: context.scaledV(4)),
                                        Text(
                                          m.desc!,
                                          style: TextStyle(
                                            fontSize: context.scaled(11),
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Container(
                                  width: context.scaled(20),
                                  height: context.scaled(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                                      width: isSelected ? 5.0 : 1.0,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    
                    SizedBox(height: context.scaledV(16)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.scaled(4)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified_user_outlined,
                            size: context.scaled(14),
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                        SizedBox(width: context.scaled(12)),
                        Expanded(
                          child: Text(
                            'Your selected method determines the final charges shown next.',
                            style: TextStyle(
                              fontSize: context.scaled(12),
                              color: const Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(32)),
                    
                    // Bottom buttons
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, // Removed horizontal padding since scroll view has it
                        context.scaled(16),
                        0,
                        MediaQuery.paddingOf(context).bottom + context.scaled(16),
                      ),
                      // Removed top border since it's no longer pinned
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: 'Continue to Terms',
                            arrow: true,
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.termsConditions);
                            },
                          ),
                          SizedBox(height: context.scaledV(12)),
                          AppOutlineButton(
                            label: 'Save and exit',
                            onPressed: () => Navigator.of(context).pop(), // Or whatever logic
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
