import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

/// Reusable order stepper — supports 6 steps, responsive sizing, 8pt grid.
/// [currentStep] is 0-based. Steps before it show a completed green checkmark.
class OrderStepperWidget extends StatelessWidget {
  const OrderStepperWidget({
    super.key,
    required this.currentStep,
    this.labels = flowLabels,
  });

  final int currentStep;
  final List<String> labels;

  static const List<String> defaultLabels = [
    'Project',
    'Mix Code',
    'Quantity',
    'Schedule',
    'Services',
    'Site Access',
    'Review',
  ];

  static const List<String> flowLabels = [
    'Project',
    'Mix Code',
    'Quantity',
    'Schedule',
    'Services',
    'Site Access',
    'Review',
  ];

  // Design tokens — ported from the new Figma design's `StepRail`
  // component (`ui.tsx`): done/active steps are both brand-purple, with a
  // ring around the active step; upcoming steps sit on a light lavender.
  static const double _connectorH = 3;

  static const Color _doneBg = AppColors.primary;
  static const Color _activeBg = AppColors.primary;
  static const Color _inactiveBg = AppColors.circleInactive;
  static const Color _inactiveText = AppColors.iconMuted;
  static const Color _connectorDone = AppColors.primary;
  static const Color _connectorGrey = AppColors.indicatorInactive;
  static const Color _activeLabel = AppColors.primary;
  static const Color _inactiveLabel = AppColors.iconMuted;

  @override
  Widget build(BuildContext context) {
    final isSixSteps = labels.length >= 6;
    final circleSize = context.scaled(isSixSteps ? 32 : 40);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Circles + connectors ──────────────────────────────────────────
        Row(
          children: List.generate(labels.length * 2 - 1, (i) {
            if (i.isOdd) {
              final connectorStep =
                  i ~/ 2; // step index to the left of this connector
              final isDone = connectorStep < currentStep;
              return Expanded(
                child: Container(
                  height: _connectorH,
                  color: isDone ? _connectorDone : _connectorGrey,
                ),
              );
            }

            final stepIndex = i ~/ 2;
            final isDone = stepIndex < currentStep;
            final isActive = stepIndex == currentStep;

            return _StepCircle(
              number: stepIndex + 1,
              isDone: isDone,
              isActive: isActive,
              size: circleSize,
              doneBg: _doneBg,
              activeBg: _activeBg,
              inactiveBg: _inactiveBg,
              inactiveTextColor: _inactiveText,
            );
          }),
        ),

        SizedBox(height: context.scaledV(6)),

        // ── Labels ────────────────────────────────────────────────────────
        Row(
          children: List.generate(labels.length, (i) {
            final isActive = i == currentStep;
            return Expanded(
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.scaled(isSixSteps ? 11 : 12),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? _activeLabel : _inactiveLabel,
                  height: 1.33,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Single step circle ────────────────────────────────────────────────────────
class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.number,
    required this.isDone,
    required this.isActive,
    required this.size,
    required this.doneBg,
    required this.activeBg,
    required this.inactiveBg,
    required this.inactiveTextColor,
  });

  final int number;
  final bool isDone;
  final bool isActive;
  final double size;
  final Color doneBg;
  final Color activeBg;
  final Color inactiveBg;
  final Color inactiveTextColor;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDone
        ? doneBg
        : isActive
        ? activeBg
        : inactiveBg;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: AppColors.primaryContainer, width: 4)
              : null,
        ),
        child: Center(
          child: isDone
              ? Icon(
                  Icons.check_rounded,
                  size: size * 0.55,
                  color: Colors.white,
                )
              : Text(
                  '$number',
                  style: TextStyle(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : inactiveTextColor,
                    height: 1,
                  ),
                ),
        ),
      ),
    );
  }
}
