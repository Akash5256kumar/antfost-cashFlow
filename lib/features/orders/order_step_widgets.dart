import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/order_stepper_widget.dart';
import '../../core/widgets/primary_button.dart';

// Aliases onto the shared design tokens — kept so the many call sites across
// the new-order wizard screens don't all need touching individually.
const Color kOrderTextDark = AppColors.textPrimary;
const Color kOrderTextGrey = AppColors.textSecondary;
const Color kOrderBodyBg = AppColors.background;
const Color kOrderBorderSect = AppColors.cardBorder;
const Color kOrderFieldBorder = AppColors.cardBorder;
const Color kOrderLabelGrey = AppColors.textSecondary;
const Color kOrderRequiredPink = Color(0xFFFF5CA8);

// ── Shared step heading ────────────────────────────────────────────────────
//
// Ported from the new Figma design's per-step body heading (`screens/
// MixCode.tsx` etc: bold H1 + optional description, below the shared
// `AppBrandHeader`/`StepRail` chrome each wizard screen now uses directly).
class OrderStepHeading extends StatelessWidget {
  const OrderStepHeading({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.scaled(20),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: context.scaledV(4)),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: context.scaled(13.5),
              fontWeight: FontWeight.w400,
              color: kOrderTextGrey,
              height: 1.4,
            ),
          ),
        ],
      ],
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
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(16),
          vertical: context.scaled(16),
        ),
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

  final VoidCallback? onContinue;
  final String label;

  @override
  Widget build(BuildContext context) {
    // Respect both the system bottom inset (nav bar / gesture area) and
    // the software keyboard height so the button is never obscured.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = bottomInset > 0
        ? bottomInset + context.scaled(12)
        : MediaQuery.paddingOf(context).bottom + context.scaled(20);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kOrderBorderSect, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.scaled(16),
          context.scaled(12),
          context.scaled(16),
          bottomPadding,
        ),
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
        final dashW = context.scaled(8.0);
        final dashGap = context.scaled(5.0);
        final count = (constraints.maxWidth / (dashW + dashGap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: EdgeInsets.only(right: dashGap),
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
