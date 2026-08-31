import 'package:flutter/material.dart';

import 'app_scale.dart';

/// Corner-radius scale ported from the new Figma design (`--radius: 16px`
/// default, buttons use the Make file's `PrimaryButton.tsx` 20px).
abstract final class AppRadii {
  /// Primary/outline/ghost CTA buttons.
  static double button(BuildContext context) => context.scaled(12);

  /// Cards, sheets, section containers.
  static double card(BuildContext context) => context.scaled(16);

  /// Text fields / bordered inputs.
  static double field(BuildContext context) => context.scaled(16);

  /// Small chips/badges that aren't fully pill-shaped.
  static double chip(BuildContext context) => context.scaled(12);

  // A large sentinel radius ("fully rounded") — scaling it is meaningless,
  // kept as a plain constant for callers that don't have a BuildContext.
  static const double full = 999;
}
