import 'package:flutter/material.dart';

import 'app_scale.dart';

abstract final class AppSpacing {
  static double xxs(BuildContext context) => context.scaled(2);
  static double xs(BuildContext context) => context.scaled(4);
  static double sm(BuildContext context) => context.scaled(8);
  static double md(BuildContext context) => context.scaled(12);
  static double lg(BuildContext context) => context.scaled(16);
  static double xl(BuildContext context) => context.scaled(22);
  static double xxl(BuildContext context) => context.scaled(28);
  static double xxxl(BuildContext context) => context.scaled(32);

  /// Top gap below safe area on logo screens (Sign In, Get Started)
  static double authLogoTop(BuildContext context) => context.scaled(100.0);

  /// Top gap below AppBar on scrollable auth screens
  static double authBodyTop(BuildContext context) => context.scaled(12.0);
  static double buttonHeight(BuildContext context) => context.scaled(58);
  static double buttonRadius(BuildContext context) => context.scaled(20);
  /// Onboarding pill-dot pagination — ported from the new Figma design
  /// (`h-2.5`, active `w-7`, inactive `w-6`).
  static double indicatorActiveWidth(BuildContext context) =>
      context.scaled(28);
  static double indicatorInactiveWidth(BuildContext context) =>
      context.scaled(24);
  static double indicatorSize(BuildContext context) => context.scaled(10);
  static double ringStroke(BuildContext context) => context.scaled(1.2);
}
