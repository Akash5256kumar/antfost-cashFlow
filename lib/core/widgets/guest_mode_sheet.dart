import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_gradient_button.dart';

// ── Local palette (specific to this Guest Mode sheet) ──────────────────────
const Color _warningBg = Color(0xFFFFC736);
const Color _warningText = Color(0xFF1A1A1A);
const Color _demoRowBg = Color(0xFFF5F5F7);
const Color _greenAccent = Color(0xFF22C55E);

/// Shows a centered dialog explaining Guest (Demo) mode limitations.
/// [onContinue] is called when the user confirms, [onSignIn] for sign-in.
Future<void> showGuestModeSheet(
  BuildContext context, {
  required VoidCallback onContinue,
  required VoidCallback onSignIn,
}) {
  return showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm(dialogContext),
      ),
      clipBehavior: Clip.none,
      // A scroll safety net that only engages if the content doesn't fit —
      // renders identically when there's room, and scrolls instead of
      // overflowing on smaller screens or with larger system font sizes.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(dialogContext).size.height * 0.88,
        ),
        child: SingleChildScrollView(
          child: GuestModeSheet(onContinue: onContinue, onSignIn: onSignIn),
        ),
      ),
    ),
  );
}

class _DemoFeature {
  final String label;
  final bool isGreen;
  const _DemoFeature(this.label, this.isGreen);
}

class GuestModeSheet extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSignIn;

  static const _bullets = [
    'You will receive demo Token m³ balance for simulation.',
    'Order history is temporary on this device.',
    'Some requests may not trigger admin follow-up.',
  ];

  static const _demoFeatures = [
    _DemoFeature('Demo Orders', false),
    _DemoFeature('Demo Projects', true),
    _DemoFeature('Demo Wallet', false),
    _DemoFeature('Demo Invoices', true),
    _DemoFeature('Demo Order Tracking', false),
  ];

  const GuestModeSheet({
    super.key,
    required this.onContinue,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    // ── White card ─────────────────────────────────────────────────────────
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg(context),
        AppSpacing.lg(context),
        AppSpacing.lg(context),
        AppSpacing.xl(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(context.scaled(24))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Close button ───────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close_rounded,
                size: context.scaled(22),
                color: AppColors.textPrimary,
              ),
            ),
          ),

          SizedBox(height: context.scaledV(4)),

          // ── Warning banner ───────────────────────────────────────────────
          _WarningBanner(),

          SizedBox(height: context.scaledV(12)),

          Text(
            'Guest Mode (Demo)',
            style: TextStyle(
              fontSize: context.scaled(20),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: context.scaledV(10)),

          // ── Bullet list ─────────────────────────────────────────────
          ..._bullets.map((text) => _Bullet(text: text)),

          SizedBox(height: context.scaledV(6)),

          // ── Demo feature rows ───────────────────────────────────────
          ..._demoFeatures.map((f) => _DemoFeatureRow(feature: f)),

          SizedBox(height: context.scaledV(4)),

          // ── Credits balance ─────────────────────────────────────────
          const _CreditsBalanceBox(),

          SizedBox(height: context.scaledV(12)),

          // ── Continue as Guest ───────────────────────────────────────
          AppGradientButton(
            label: 'Continue as Guest',
            onPressed: () {
              Navigator.pop(context);
              onContinue();
            },
          ),

          SizedBox(height: context.scaledV(12)),

          // ── Sign In Instead ─────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSignIn();
              },
              child: Text(
                'Sign In Instead',
                style: AppTextStyles.authLink(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Warning banner ───────────────────────────────────────────────────────────
class _WarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md(context),
        vertical: context.scaledV(10),
      ),
      decoration: BoxDecoration(
        color: _warningBg,
        borderRadius: BorderRadius.circular(context.scaled(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: context.scaled(16),
            color: _warningText,
          ),
          SizedBox(width: context.scaled(8)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Guest Mode: ',
                    style: TextStyle(
                      fontSize: context.scaled(13),
                      fontWeight: FontWeight.w700,
                      color: _warningText,
                      height: 1.4,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Cannot place real orders, make payments, or book deliveries',
                    style: TextStyle(
                      fontSize: context.scaled(13),
                      fontWeight: FontWeight.w500,
                      color: _warningText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Demo feature row (accent bar + label + DEMO badge) ────────────────────────
class _DemoFeatureRow extends StatelessWidget {
  const _DemoFeatureRow({required this.feature});
  final _DemoFeature feature;

  @override
  Widget build(BuildContext context) {
    final Color accent = feature.isGreen ? _greenAccent : AppColors.primary;
    return Container(
      margin: EdgeInsets.only(bottom: context.scaledV(6)),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _demoRowBg,
        borderRadius: BorderRadius.circular(context.scaled(12)),
      ),
      child: Row(
        children: [
          Container(
            width: context.scaled(4),
            height: context.scaled(32),
            color: accent,
          ),
          SizedBox(width: context.scaled(12)),
          Expanded(
            child: Text(
              feature.label,
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: context.scaled(12)),
            padding: EdgeInsets.symmetric(
              horizontal: context.scaled(10),
              vertical: context.scaledV(4),
            ),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.scaled(20)),
            ),
            child: Text(
              'DEMO',
              style: TextStyle(
                fontSize: context.scaled(11),
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Demo credits balance box ──────────────────────────────────────────────────
class _CreditsBalanceBox extends StatelessWidget {
  const _CreditsBalanceBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md(context),
        vertical: context.scaledV(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.scaled(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo Credits Balance',
            style: TextStyle(
              fontSize: context.scaled(12),
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: context.scaledV(2)),
          Text(
            '500 Demo m³ Tokens',
            style: TextStyle(
              fontSize: context.scaled(18),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.scaledV(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.scaled(5)),
            child: Icon(
              Icons.circle,
              size: context.scaled(6),
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: AppSpacing.sm(context)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: context.scaled(14),
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
