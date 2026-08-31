import 'package:flutter/material.dart';

/// Design tokens ported from the new Figma ("Antfast-updated-design") Make
/// file — see `src/index.css` in that file for the source CSS variables.
/// Every screen should pull colors from here rather than hardcoding literals
/// or defining private per-screen palettes.
abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);

  // Brand purple — single source of truth for every button, container tint,
  // and text/link color across the app. (Figma --primary / --primary-hover)
  static const Color primary = Color(0xFF5B4BE0);
  static const Color primaryPressed = Color(0xFF4A3BD0);
  static const Color primaryContainer = Color(0xFFEFEDFD); // --primary-soft
  static const Color primaryGradientStart = primary;
  static const Color primaryGradientEnd = primary;

  static const Color textPrimary = Color(0xFF16151F); // --foreground
  static const Color textSecondary = Color(0xFF6D6B86); // --muted-foreground
  static const Color textHint = Color(0xFFA3A1B8);
  static const Color iconMuted = Color(0xFF9B99B3);

  static const Color indicatorInactive = Color(0xFFE2E0EF);
  static const Color circleInactive = Color(0xFFE6E4F1);
  static const Color splashBlob = primaryContainer;
  static const Color onboardingBlob = primaryContainer;
  static const Color ringSoft = Color(0x70F6CDD9);
  static const Color ringSplash = primaryContainer;

  // Auth screens
  static const Color fieldBorder = Color(0xFFECECF3); // --border
  static const Color fieldBg = Color(0xFFFFFFFF);
  static const Color fieldActiveBg = Color(0xFFFFFFFF); // stays white on focus
  static const Color divider = Color(0xFFECECF3);
  static const Color link = primary;
  static const Color outlineBtnBorder = Color(0xFFD4D4D4);
  static const Color checkboxBorder = Color(0xFFD0CDE8);

  // Surface & Layout
  static const Color background = Color(0xFFF5F4FA); // --background / --page
  static const Color cardBorder = Color(0xFFECECF3); // --border
  static const Color muted = Color(0xFFF2F1F9); // --muted (chips/segmented bg)
  static const Color textDark = Color(0xFF16151F);

  // Status & Badges
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFE7F6EC); // --success-soft
  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFDF1E3); // --warning-soft
  static const Color infoContainer = Color(0xFFEAF1FD); // --info-soft
  static const Color infoText = Color(0xFF3B6FD6); // "scheduled" badge text
  static const Color error = Color(0xFFEF4444);
}
