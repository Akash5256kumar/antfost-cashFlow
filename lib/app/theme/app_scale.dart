import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/app_breakpoints.dart';

/// Screen-width-relative scaling, generalising the proportional-sizing
/// approach already used by the onboarding/splash screens to the rest of
/// the app's design tokens and raw literals.
abstract final class AppScale {
  /// Design reference width (logical px) that a scale of 1.0 corresponds to.
  static const double referenceWidth = 375.0;

  /// Design reference height (logical px) — paired with [referenceWidth] as
  /// the classic 375×667 (iPhone 8) baseline frame.
  static const double referenceHeight = 667.0;
  static const double minScale = 0.85;
  static const double maxScale = 1.15;
}

extension ScreenScaleX on BuildContext {
  // Capped at the app-wide tablet breakpoint to stay consistent with the
  // max-width constraint main.dart already applies via MaterialApp.builder —
  // uncapped device width would make scale blow past maxScale on tablets.
  double get _effectiveWidth =>
      math.min(MediaQuery.sizeOf(this).width, AppBreakpoints.tablet);

  /// Clamped scale factor derived from the current effective screen width.
  /// Drives horizontal-ish sizing: fontSize, icon size, radius, horizontal
  /// padding/gaps — quantities that track screen density more than the
  /// device's actual height.
  double get scale => (_effectiveWidth / AppScale.referenceWidth).clamp(
    AppScale.minScale,
    AppScale.maxScale,
  );

  /// Clamped scale factor derived from the current screen height. Drives
  /// purely vertical spacing (SizedBox height, vertical padding/gaps) so
  /// that unusually short/tall devices don't inherit a horizontal-only
  /// scale for a dimension it doesn't actually describe.
  double get scaleV => (MediaQuery.sizeOf(this).height / AppScale.referenceHeight)
      .clamp(AppScale.minScale, AppScale.maxScale);

  /// Scales a raw dp value by [scale]. For one-off horizontal/density literal
  /// call sites (fontSize, icon size, radius, horizontal spacing).
  double scaled(double value) => value * scale;

  /// Scales a raw dp value by [scaleV]. For one-off purely-vertical literal
  /// call sites (SizedBox height, top/bottom padding).
  double scaledV(double value) => value * scaleV;
}
