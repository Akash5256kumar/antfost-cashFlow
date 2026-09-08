import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_outline_button.dart';

enum _SecondaryMethod { card, bank, cash }

class SplitWalletPaymentScreen extends StatefulWidget {
  const SplitWalletPaymentScreen({
    super.key,
    this.totalAmount = 31920.0,
    this.walletBalance = 24850.0,
  });

  final double totalAmount;
  final double walletBalance;

  @override
  State<SplitWalletPaymentScreen> createState() =>
      _SplitWalletPaymentScreenState();
}

class _SplitWalletPaymentScreenState extends State<SplitWalletPaymentScreen> {
  _SecondaryMethod _selected = _SecondaryMethod.card;

  String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final buf = StringBuffer();
    for (var i = 0; i < parts[0].length; i++) {
      if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
      buf.write(parts[0][i]);
    }
    return 'AED $buf.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.totalAmount - widget.walletBalance;
    final walletPct = (widget.walletBalance / widget.totalAmount).clamp(0.0, 1.0);

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
                    Text(
                      'Split Wallet Payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(22),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1B4B),
                      ),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    Text(
                      'Total order amount',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      _fmt(widget.totalAmount),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(24),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1B4B),
                      ),
                    ),
                    
                    SizedBox(height: context.scaledV(24)),
                    
                    // Donut Chart Card
                    Container(
                      padding: EdgeInsets.all(context.scaled(20)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          // Chart
                          SizedBox(
                            width: context.scaled(110),
                            height: context.scaled(110),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: context.scaled(110),
                                  height: context.scaled(110),
                                  child: CircularProgressIndicator(
                                    value: walletPct,
                                    strokeWidth: context.scaled(12),
                                    backgroundColor: const Color(0xFFEAE5FF),
                                    valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Wallet',
                                      style: TextStyle(
                                        fontSize: context.scaled(11),
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                    Text(
                                      '${(walletPct * 100).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: context.scaled(18),
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1E1B4B),
                                      ),
                                    ),
                                    Text(
                                      _fmt(widget.walletBalance).replaceAll('AED ', ''),
                                      style: TextStyle(
                                        fontSize: context.scaled(9),
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: context.scaled(24)),
                          
                          // Legend
                          Expanded(
                            child: Column(
                              children: [
                                _LegendRow(
                                  icon: Icons.account_balance_wallet_outlined,
                                  title: 'From Wallet',
                                  pct: '${(walletPct * 100).toStringAsFixed(1)}%',
                                  amount: _fmt(widget.walletBalance),
                                ),
                                SizedBox(height: context.scaledV(16)),
                                _LegendRow(
                                  icon: Icons.credit_card_outlined,
                                  title: 'Remaining Amount',
                                  pct: '${((1.0 - walletPct) * 100).toStringAsFixed(1)}%',
                                  amount: _fmt(remaining),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: context.scaledV(32)),
                    Text(
                      'Choose one method for the remaining amount',
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1B4B),
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      'Wallet may combine with exactly ONE secondary method.',
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    
                    SizedBox(height: context.scaledV(16)),
                    
                    // Options
                    _MethodOption(
                      id: _SecondaryMethod.card,
                      selectedId: _selected,
                      icon: Icons.credit_card_outlined,
                      title: 'Card / Payment Link',
                      subtitle: 'Pay securely using your card or a payment link',
                      onTap: () => setState(() => _selected = _SecondaryMethod.card),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    _MethodOption(
                      id: _SecondaryMethod.bank,
                      selectedId: _selected,
                      icon: Icons.account_balance_outlined,
                      title: 'Bank Transfer',
                      subtitle: 'Direct transfer from your bank account',
                      onTap: () => setState(() => _selected = _SecondaryMethod.bank),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    _MethodOption(
                      id: _SecondaryMethod.cash,
                      selectedId: _selected,
                      icon: Icons.payments_outlined,
                      title: 'Cash in Advance',
                      subtitle: 'Pay in cash before order confirmation',
                      onTap: () => setState(() => _selected = _SecondaryMethod.cash),
                    ),
                    
                    SizedBox(height: context.scaledV(16)),
                    
                    // Info alert
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: context.scaled(14),
                          color: const Color(0xFF64748B),
                        ),
                        SizedBox(width: context.scaled(6)),
                        Text(
                          'Wallet funds are reserved only after you continue.',
                          style: TextStyle(
                            fontSize: context.scaled(11),
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(32)),
                    
                    // Bottom buttons
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        context.scaled(16),
                        0,
                        MediaQuery.paddingOf(context).bottom + context.scaled(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: 'Continue',
                            arrow: true,
                            onPressed: () {
                              String nextRoute;
                              switch (_selected) {
                                case _SecondaryMethod.card:
                                  nextRoute = AppRoutes.completePayment;
                                  break;
                                case _SecondaryMethod.bank:
                                  nextRoute = AppRoutes.uploadPaymentProof;
                                  break;
                                case _SecondaryMethod.cash:
                                  nextRoute = AppRoutes.paymentSuccess;
                                  break;
                              }
                              Navigator.of(context).pushNamed(
                                AppRoutes.termsConditions,
                                arguments: nextRoute,
                              );
                            },
                          ),
                          SizedBox(height: context.scaledV(12)),
                          AppOutlineButton(
                            label: 'Use another payment method',
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

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.icon,
    required this.title,
    required this.pct,
    required this.amount,
  });

  final IconData icon;
  final String title;
  final String pct;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.scaled(8)),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(context.scaled(8)),
          ),
          child: Icon(
            icon,
            size: context.scaled(16),
            color: const Color(0xFF8B5CF6),
          ),
        ),
        SizedBox(width: context.scaled(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: context.scaled(11),
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: context.scaledV(2)),
              Text(
                pct,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
              SizedBox(height: context.scaledV(6)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(8),
                  vertical: context.scaledV(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(context.scaled(4)),
                ),
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1B4B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.id,
    required this.selectedId,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final _SecondaryMethod id;
  final _SecondaryMethod selectedId;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = id == selectedId;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.scaled(16)),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(12)),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.scaled(10)),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(context.scaled(8)),
              ),
              child: Icon(
                icon,
                size: context.scaled(20),
                color: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(width: context.scaled(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: context.scaled(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E1B4B),
                    ),
                  ),
                  SizedBox(height: context.scaledV(4)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: context.scaled(11),
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.scaled(12)),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: context.scaled(24),
                color: AppColors.primary,
              )
            else
              Container(
                width: context.scaled(24),
                height: context.scaled(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
