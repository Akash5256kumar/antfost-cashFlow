import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/order_stepper_widget.dart';
import '../../core/widgets/primary_button.dart';

const Color kOrderTextDark    = Color(0xFF1A1A1A);
const Color kOrderTextGrey    = Color(0xFF9E9E9E);
const Color kOrderBodyBg      = Color(0xFFF2F2F7);
const Color kOrderBorderSect  = Color(0xFFEFEFEF);
const Color kOrderFieldBorder = Color(0xFFE8E8E8);
const Color kOrderLabelGrey   = Color(0xFF9F9DA6);
const Color kOrderRequiredPink = Color(0xFFFF5CA8);

// ── Shared app bar ────────────────────────────────────────────────────────────

class OrderStepAppBar extends StatelessWidget {
  const OrderStepAppBar({super.key, required this.subtitle});
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New Cash Order',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: kOrderTextGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared stepper section ────────────────────────────────────────────────────

class OrderStepperSection extends StatelessWidget {
  const OrderStepperSection({
    super.key,
    required this.currentStep,
    this.labels = OrderStepperWidget.flowLabels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: kOrderBorderSect, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: OrderStepperWidget(currentStep: currentStep, labels: labels),
      ),
    );
  }
}

// ── Shared bottom bar ─────────────────────────────────────────────────────────

class OrderStepBottomBar extends StatelessWidget {
  const OrderStepBottomBar({
    super.key,
    required this.onContinue,
    this.label = 'Continue',
  });

  final VoidCallback onContinue;
  final String label;

  @override
  Widget build(BuildContext context) {
    // Respect both the system bottom inset (nav bar / gesture area) and
    // the software keyboard height so the button is never obscured.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = bottomInset > 0
        ? bottomInset + 12
        : MediaQuery.paddingOf(context).bottom + 20;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kOrderBorderSect, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
        child: PrimaryButton(label: label, onPressed: onContinue),
      ),
    );
  }
}

// ── Dashed divider ────────────────────────────────────────────────────────────

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key, this.color = const Color(0xFFDDDDDD)});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashW = 8.0;
        const dashGap = 5.0;
        final count = (constraints.maxWidth / (dashW + dashGap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(right: dashGap),
              child: SizedBox(
                width: dashW,
                height: 1,
                child: ColoredBox(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}
