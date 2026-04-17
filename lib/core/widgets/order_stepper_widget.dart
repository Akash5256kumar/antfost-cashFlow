import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Reusable order stepper — 5 steps, 44 px circles, 8pt spacing grid.
/// [currentStep] is 0-based. Steps before it show a completed checkmark.
class OrderStepperWidget extends StatelessWidget {
  const OrderStepperWidget({
    super.key,
    required this.currentStep,
    this.labels = defaultLabels,
  });

  final int currentStep;
  final List<String> labels;

  static const List<String> defaultLabels = [
    'Project',
    'Mix Code',
    'Quantity',
    'Schedule',
    'Other',
  ];

  static const List<String> flowLabels = [
    'Location',
    'Mix Code',
    'Quantity',
    'Schedule',
    'Other',
  ];

  // Design tokens
  static const double _circleSize    = 44;
  static const double _connectorH    = 2;
  static const double _labelFontSize = 12;

  static const Color _doneBg         = AppColors.primary;
  static const Color _activeBg       = AppColors.primary;
  static const Color _inactiveBg     = Color(0xFFF1F1F1);
  static const Color _inactiveText   = Color(0xFF111111);
  static const Color _connectorDone  = AppColors.primary;
  static const Color _connectorGrey  = Color(0xFFEFEFEF);
  static const Color _activeLabel    = AppColors.primary;
  static const Color _inactiveLabel  = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Circles + connectors ──────────────────────────────────────────
        Row(
          children: List.generate(labels.length * 2 - 1, (i) {
            if (i.isOdd) {
              final connectorStep = i ~/ 2; // step index to the left of this connector
              final isDone = connectorStep < currentStep;
              return Expanded(
                child: Container(
                  height: _connectorH,
                  color: isDone ? _connectorDone : _connectorGrey,
                ),
              );
            }

            final stepIndex = i ~/ 2;
            final isDone   = stepIndex < currentStep;
            final isActive = stepIndex == currentStep;

            return _StepCircle(
              number:   stepIndex + 1,
              isDone:   isDone,
              isActive: isActive,
              size:     _circleSize,
              doneBg:   _doneBg,
              activeBg: _activeBg,
              inactiveBg: _inactiveBg,
              inactiveTextColor: _inactiveText,
            );
          }),
        ),

        const SizedBox(height: 8),

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
                  fontSize: _labelFontSize,
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
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Center(
          child: isDone
              ? const Icon(Icons.check_rounded, size: 20, color: Colors.white)
              : Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 16,
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
