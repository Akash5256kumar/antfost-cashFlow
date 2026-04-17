import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_gradient_button.dart';

/// Shows a bottom sheet explaining Guest (Demo) mode limitations.
/// [onContinue] is called when the user confirms, [onSignIn] for sign-in.
Future<void> showGuestModeSheet(
  BuildContext context, {
  required VoidCallback onContinue,
  required VoidCallback onSignIn,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => GuestModeSheet(
      onContinue: onContinue,
      onSignIn: onSignIn,
    ),
  );
}

class GuestModeSheet extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSignIn;

  static const _bullets = [
    'You will receive demo Token m³ balance for simulation.',
    'Order history is temporary on this device.',
    'Some requests may not trigger admin follow-up.',
  ];

  const GuestModeSheet({
    super.key,
    required this.onContinue,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        bottomInset > 0 ? bottomInset + AppSpacing.md : AppSpacing.xxl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ────────────────────────────────────────────────────
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Guest Mode (Demo)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Bullet list ───────────────────────────────────────────────────
          ..._bullets.map((text) => _Bullet(text: text)),

          const SizedBox(height: AppSpacing.xxl),

          // ── Continue as Guest ─────────────────────────────────────────────
          AppGradientButton(
            label: 'Continue as Guest',
            onPressed: () {
              Navigator.pop(context);
              onContinue();
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Sign In Instead ───────────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSignIn();
              },
              child: const Text(
                'Sign In Instead',
                style: AppTextStyles.authLink,
              ),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 6, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
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
