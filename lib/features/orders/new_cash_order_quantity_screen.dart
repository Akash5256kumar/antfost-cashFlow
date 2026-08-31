import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import 'agreement_summary_screen.dart';
import 'operations_agreement_sheet.dart';
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
  bool _isAgreementAccepted = false;

  bool get _needsReview => _quantity > 100;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  Future<void> _handleViewAgreement() async {
    if (_isAgreementAccepted) {
      OperationsAgreementSheet.show(
        context,
        approvedQuantity: _quantity,
      );
      return;
    }

    final accepted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AgreementSummaryScreen(
          concreteGrade: widget.mixCode.code,
          approvedVolume: _quantity,
          buttonText: 'Accept Agreement',
        ),
      ),
    );

    if (accepted == true && mounted) {
      setState(() => _isAgreementAccepted = true);
      OperationsAgreementSheet.show(
        context,
        approvedQuantity: _quantity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const AppBrandHeader(showBack: true),
            const OrderStepperSection(currentStep: 2),

            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(20),
                    context.scaled(20),
                    context.scaled(20),
                    context.scaled(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Quantity',
                        style: TextStyle(
                          fontSize: context.scaled(24),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: context.scaledV(16)),

                      // Hero illustration
                      Center(
                        child: SizedBox(
                          height: context.scaled(200),
                          child: Image.asset(
                            AppAssets.artConcreteCube,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(20)),

                      // ── +/- stepper card ──────────────────────────
                      _QuantityStepperCard(
                        quantity: _quantity,
                        onDecrement: _decrement,
                        onIncrement: _increment,
                      ),
                      SizedBox(height: context.scaledV(20)),

                      // ── Inline Continue Button ────────────────────
                      PrimaryButton(
                        arrow: true,
                        label: 'Continue to Schedule',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NewCashOrderScheduleScreen(
                              mixCode: widget.mixCode,
                              quantity: _quantity,
                            ),
                          ),
                        ),
                      ),

                      // ── Manual review warning ─────────────────────
                      if (_needsReview) ...[
                        SizedBox(height: context.scaledV(20)),
                        _ManualReviewBanner(
                          mixCode: widget.mixCode.code,
                          quantity: _quantity,
                          isAccepted: _isAgreementAccepted,
                          onTap: _handleViewAgreement,
                        ),
                      ],
                    ],
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(16),
        vertical: context.scaledV(20),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent, // "ander bhi whi color rahga jo bahar j"
        borderRadius: BorderRadius.circular(context.scaled(20)),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Minus
              _StepperButton(
                icon: Icons.remove_rounded,
                onTap: onDecrement,
              ),

              // Quantity display
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: context.scaled(64),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      height: 1.0,
                      letterSpacing: -1.0,
                    ),
                  ),
                  SizedBox(height: context.scaledV(4)),
                  Text(
                    'm³',
                    style: TextStyle(
                      fontSize: context.scaled(15),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              // Plus
              _StepperButton(
                icon: Icons.add_rounded,
                onTap: onIncrement,
              ),
            ],
          ),
          SizedBox(height: context.scaledV(20)),

          // Helper note inside card
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_outlined,
                size: context.scaled(16),
                color: const Color(0xFF94A3B8),
              ),
              SizedBox(width: context.scaled(8)),
              Text(
                'Enter exact required volume',
                style: TextStyle(
                  fontSize: context.scaled(12.5),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.scaled(60),
        height: context.scaled(48),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EEFE),
          borderRadius: BorderRadius.circular(context.scaled(14)),
        ),
        child: Icon(
          icon,
          size: context.scaled(24),
          color: AppColors.primary,
        ),
      ),
    );
  }
}



// ── Manual review banner ──────────────────────────────────────────────────────

class _ManualReviewBanner extends StatelessWidget {
  const _ManualReviewBanner({
    required this.mixCode,
    required this.quantity,
    this.isAccepted = false,
    this.onTap,
  });

  final String mixCode;
  final int quantity;
  final bool isAccepted;
  final VoidCallback? onTap;

  static const Color _warningColor = Color(0xFFFF5CA8);
  static const Color _bgColor = Color(0xFFFFF0F5);
  static const Color _acceptedColor = Color(0xFF5A45FF);
  static const Color _acceptedBgColor = Color(0xFFF3F0FF);

  @override
  Widget build(BuildContext context) {
    if (isAccepted) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.scaled(14)),
        decoration: BoxDecoration(
          color: _acceptedBgColor,
          borderRadius: BorderRadius.circular(context.scaled(12)),
          border: Border.all(color: _acceptedColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: context.scaled(20),
                  color: const Color(0xFF22C55E),
                ),
                SizedBox(width: context.scaled(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feasibility Agreement Accepted',
                        style: TextStyle(
                          fontSize: context.scaled(14),
                          fontWeight: FontWeight.w600,
                          color: _acceptedColor,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: context.scaledV(4)),
                      Text(
                        'Agreement approved for $quantity m³. Operations schedule is locked.',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF444444),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.scaledV(10)),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(12),
                  vertical: context.scaledV(6),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(context.scaled(8)),
                  border:
                      Border.all(color: _acceptedColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Operations Summary',
                      style: TextStyle(
                        fontSize: context.scaled(12.5),
                        fontWeight: FontWeight.w600,
                        color: _acceptedColor,
                      ),
                    ),
                    SizedBox(width: context.scaled(4)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: context.scaled(11),
                      color: _acceptedColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scaled(14)),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(context.scaled(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: context.scaled(20),
                color: _warningColor,
              ),
              SizedBox(width: context.scaled(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manual Review Required',
                      style: TextStyle(
                        fontSize: context.scaled(14),
                        fontWeight: FontWeight.w600,
                        color: _warningColor,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      'Orders above 100 m³ require manual feasibility review. Our team will contact you.',
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF444444),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaledV(10)),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaled(12),
                vertical: context.scaledV(6),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.scaled(8)),
                border: Border.all(color: _warningColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Feasibility Agreement',
                    style: TextStyle(
                      fontSize: context.scaled(12.5),
                      fontWeight: FontWeight.w600,
                      color: _warningColor,
                    ),
                  ),
                  SizedBox(width: context.scaled(4)),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: context.scaled(11),
                    color: _warningColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
