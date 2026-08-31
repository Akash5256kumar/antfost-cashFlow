import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_scale.dart';

/// Typography scale ported from the new Figma design (Poppins, sizes taken
/// from `ui.tsx` / `PrimaryButton.tsx` in the "Antfast-updated-design" Make
/// file). All methods keep taking `BuildContext` so the existing
/// width/height-proportional scaling (`context.scaled`) is preserved.
abstract final class AppTextStyles {
  static TextStyle onboardingTitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(22),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.28,
    letterSpacing: -0.01 * 22,
  );

  static TextStyle onboardingSubtitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(13),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.55,
  );

  static TextStyle primaryButton(BuildContext context) => TextStyle(
    fontSize: context.scaled(15.5),
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Auth screens
  static TextStyle authScreenTitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(22),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle authScreenSubtitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(14),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle fieldLabel(BuildContext context) => TextStyle(
    fontSize: context.scaled(12),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );

  static TextStyle fieldValue(BuildContext context) => TextStyle(
    fontSize: context.scaled(15),
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle authNote(BuildContext context) => TextStyle(
    fontSize: context.scaled(12),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle authLink(BuildContext context) => TextStyle(
    fontSize: context.scaled(14),
    fontWeight: FontWeight.w600,
    color: AppColors.link,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.link,
  );

  static TextStyle outlineButton(BuildContext context) => TextStyle(
    fontSize: context.scaled(15.5),
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.2,
  );

  // ------------------------------------------------------------- Chrome

  /// `TitleHeader` screen title (back button + centered title).
  static TextStyle screenTitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(17),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Section/card heading within a screen body.
  static TextStyle cardTitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(15),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle cardSubtitle(BuildContext context) => TextStyle(
    fontSize: context.scaled(13),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// `Segmented` control option label.
  static TextStyle segmentedLabel(BuildContext context) => TextStyle(
    fontSize: context.scaled(14),
    fontWeight: FontWeight.w600,
  );

  /// `Chips` filter option label.
  static TextStyle chipLabel(BuildContext context) => TextStyle(
    fontSize: context.scaled(13),
    fontWeight: FontWeight.w500,
  );

  /// `Badge` status pill label.
  static TextStyle badgeLabel(BuildContext context) => TextStyle(
    fontSize: context.scaled(11),
    fontWeight: FontWeight.w600,
  );

  /// `StepRail` step label under each numbered circle.
  static TextStyle stepLabel(BuildContext context) => TextStyle(
    fontSize: context.scaled(10),
    fontWeight: FontWeight.w500,
    color: AppColors.iconMuted,
  );

  static TextStyle stepLabelActive(BuildContext context) => TextStyle(
    fontSize: context.scaled(10),
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// Large price/amount display (review, price breakdown, wallet balance).
  static TextStyle amountLarge(BuildContext context) => TextStyle(
    fontSize: context.scaled(28),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}
