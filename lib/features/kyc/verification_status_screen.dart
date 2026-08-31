import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';

// ── Local palette, derived from the shared design tokens ───────────────────
const Color _successBg = AppColors.successContainer;
final Color _successBorder = AppColors.success.withValues(alpha: 0.3);
const Color _successText = AppColors.success;
final Color _progressBorder = AppColors.primary.withValues(alpha: 0.25);
const Color _estimateBg = AppColors.warningContainer;
final Color _estimateBorder = AppColors.warning.withValues(alpha: 0.3);
const Color _estimateText = AppColors.warning;
const Color _trackerBg = AppColors.muted;

/// Shown after a business's KYC documents have been submitted — a richer,
/// step-tracked status screen (separate from [KycPendingScreen], which
/// remains the simpler pending-review screen used elsewhere).
class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _StatusAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg(context),
                ),
                child: Column(
                  children: [
                    SizedBox(height: context.scaledV(16)),

                    // ── Checkmark badge ────────────────────────────────────
                    const _CheckmarkBadge(),

                    SizedBox(height: context.scaledV(20)),

                    // ── Success pill ───────────────────────────────────────
                    const _SuccessPill(),

                    SizedBox(height: context.scaledV(20)),

                    // ── Title ──────────────────────────────────────────────
                    Text(
                      'Verification In Progress',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(24),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),

                    SizedBox(height: context.scaledV(8)),

                    // ── Subtitle ───────────────────────────────────────────
                    Text(
                      "Your documents are under review. We'll notify you "
                      'once verification is complete.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: context.scaledV(20)),

                    // ── Verification in progress card ─────────────────────
                    _InfoCard(
                      bg: AppColors.primaryContainer,
                      border: _progressBorder,
                      accent: AppColors.primary,
                      filled: false,
                      title: 'Verification In Progress',
                      titleColor: AppColors.primary,
                      subtitle: 'Our team is reviewing your documents',
                    ),

                    SizedBox(height: context.scaledV(12)),

                    // ── Estimated time card ────────────────────────────────
                    _InfoCard(
                      bg: _estimateBg,
                      border: _estimateBorder,
                      accent: _estimateText,
                      filled: true,
                      title: 'Estimated Verification Time',
                      titleColor: AppColors.textSecondary,
                      subtitle: '2 Hours',
                      subtitleStyle: TextStyle(
                        fontSize: context.scaled(20),
                        fontWeight: FontWeight.w800,
                        color: _estimateText,
                      ),
                    ),

                    SizedBox(height: context.scaledV(16)),

                    // ── Step tracker ───────────────────────────────────────
                    const _StepTracker(),

                    SizedBox(height: context.scaledV(24)),

                    // ── Go to Home ─────────────────────────────────────────
                    PrimaryButton(
                      label: 'Go to Home',
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false),
                    ),

                    SizedBox(height: context.scaledV(16)),

                    // ── Need help ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Need help? ',
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Contact Support',
                            style: TextStyle(
                              fontSize: context.scaled(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.scaledV(14)),

                    // ── Footer note ────────────────────────────────────────
                    Text(
                      'You can check your verification status anytime in '
                      'your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: context.scaledV(16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _StatusAppBar extends StatelessWidget {
  const _StatusAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg(context),
        vertical: AppSpacing.md(context),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: context.scaled(40),
              height: context.scaled(40),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: context.scaled(20),
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md(context)),
          Text(
            'Verification Status',
            style: TextStyle(
              fontSize: context.scaled(20),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Checkmark badge (double ring) ───────────────────────────────────────────────
class _CheckmarkBadge extends StatelessWidget {
  const _CheckmarkBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.scaled(140),
        height: context.scaled(140),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Container(
          width: context.scaled(88),
          height: context.scaled(88),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: context.scaled(44),
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

// ── Success pill ─────────────────────────────────────────────────────────────
class _SuccessPill extends StatelessWidget {
  const _SuccessPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg(context),
        vertical: context.scaledV(10),
      ),
      decoration: BoxDecoration(
        color: _successBg,
        borderRadius: BorderRadius.circular(context.scaled(24)),
        border: Border.all(color: _successBorder),
      ),
      child: Text(
        'Documents Submitted Successfully',
        style: TextStyle(
          fontSize: context.scaled(14),
          fontWeight: FontWeight.w600,
          color: _successText,
        ),
      ),
    );
  }
}

// ── Info card (progress / estimated-time) ──────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final Color bg;
  final Color border;
  final Color accent;
  final bool filled;
  final String title;
  final Color titleColor;
  final String subtitle;
  final TextStyle? subtitleStyle;

  const _InfoCard({
    required this.bg,
    required this.border,
    required this.accent,
    required this.filled,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg(context)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: context.scaled(36),
            height: context.scaled(36),
            decoration: BoxDecoration(
              color: filled ? accent : AppColors.white,
              shape: BoxShape.circle,
              border: filled ? null : Border.all(color: accent, width: 2),
            ),
          ),
          SizedBox(width: AppSpacing.md(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.scaled(14),
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: context.scaledV(4)),
                Text(
                  subtitle,
                  style:
                      subtitleStyle ??
                      TextStyle(
                        fontSize: context.scaled(13),
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step tracker ──────────────────────────────────────────────────────────────
class _StepTracker extends StatelessWidget {
  const _StepTracker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md(context),
        vertical: context.scaledV(18),
      ),
      decoration: BoxDecoration(
        color: _trackerBg,
        borderRadius: BorderRadius.circular(context.scaled(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepItem(label: 'Submitted', color: _successText, filled: true),
          _StepConnector(color: AppColors.primary),
          _StepItem(
            label: 'In Review',
            color: AppColors.primary,
            filled: false,
          ),
          _StepConnector(color: AppColors.fieldBorder),
          _StepItem(
            label: 'Approved',
            color: AppColors.fieldBorder,
            labelColor: AppColors.textSecondary,
            filled: false,
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String label;
  final Color color;
  final Color? labelColor;
  final bool filled;

  const _StepItem({
    required this.label,
    required this.color,
    required this.filled,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.scaled(22),
          height: context.scaled(22),
          decoration: BoxDecoration(
            color: filled ? color : AppColors.white,
            shape: BoxShape.circle,
            border: filled ? null : Border.all(color: color, width: 2),
          ),
        ),
        SizedBox(height: context.scaledV(6)),
        Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(12),
            fontWeight: FontWeight.w600,
            color: labelColor ?? color,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final Color color;
  const _StepConnector({required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          top: context.scaled(11),
          left: context.scaled(4),
          right: context.scaled(4),
        ),
        child: Container(height: 2, color: color),
      ),
    );
  }
}
