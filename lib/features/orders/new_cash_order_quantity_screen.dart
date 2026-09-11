import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../payment/payment_success_screen.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_schedule_screen.dart';
import 'new_cash_order_draft.dart';
import '../../core/utils/route_feedback.dart';
import 'order_step_widgets.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderQuantityScreen extends StatefulWidget {
  const NewCashOrderQuantityScreen({
    super.key,
    required this.mixCode,
    this.draft,
  });
  final MixCodeItem mixCode;
  final NewCashOrderDraft? draft;

  @override
  State<NewCashOrderQuantityScreen> createState() =>
      _NewCashOrderQuantityScreenState();
}

class _NewCashOrderQuantityScreenState
    extends State<NewCashOrderQuantityScreen> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.draft?.quantity ?? 25;
  }

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  Future<void> _enterExactQuantity() async {
    final controller = TextEditingController(text: _quantity.toString());
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
    final newQuantity = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Exact Volume (m³)'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            onSubmitted: (text) {
              final val = int.tryParse(text);
              if (val != null && val > 0) {
                Navigator.of(context).pop(val);
              }
            },
            decoration: const InputDecoration(
              hintText: 'e.g. 50',
              suffixText: 'm³',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final val = int.tryParse(controller.text);
                if (val != null && val > 0) {
                  Navigator.of(context).pop(val);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newQuantity != null && mounted) {
      setState(() => _quantity = newQuantity);
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
                        onEnterExact: _enterExactQuantity,
                      ),
                      SizedBox(height: context.scaledV(20)),

                      // ── Inline Continue Button ────────────────────
                      PrimaryButton(
                        arrow: true,
                        label: 'Continue to Schedule',
                        onPressed: () {
                          if (_quantity <= 0) {
                            showAppSnackBar(
                              context,
                              'Quantity must be greater than 0.',
                            );
                            return;
                          }
                          PaymentSuccessScreen.currentOrderQuantity = _quantity;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NewCashOrderScheduleScreen(
                                mixCode: widget.mixCode,
                                quantity: _quantity,
                                draft: widget.draft?.copyWith(
                                  quantity: _quantity,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
    required this.onEnterExact,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onEnterExact;

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
              _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),

              // Quantity display (tap to enter exact volume)
              GestureDetector(
                onTap: onEnterExact,
                behavior: HitTestBehavior.opaque,
                child: Column(
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
              ),

              // Plus
              _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
            ],
          ),
          SizedBox(height: context.scaledV(20)),

          // Helper note inside card
          GestureDetector(
            onTap: onEnterExact,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.scaledV(8)),
              child: Row(
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
            ),
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
        child: Icon(icon, size: context.scaled(24), color: AppColors.primary),
      ),
    );
  }
}
