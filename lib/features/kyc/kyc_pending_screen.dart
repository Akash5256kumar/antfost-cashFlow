import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_outline_button.dart';

// ── Local colours ─────────────────────────────────────────────────────────────
const Color _badgeBg = Color(0xFFEDE9FD);
const Color _infoBg = Color(0xFFEDE9FD);
const Color _infoIcon = Color(0xFF7A6BFF);

class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Centred status content ───────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Hourglass illustration ─────────────────────────────
                    const Text('⏳', style: TextStyle(fontSize: 88, height: 1)),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Pending badge ──────────────────────────────────────
                    const _PendingBadge(),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── Title ──────────────────────────────────────────────
                    const Text(
                      'Verification Pending',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Subtitle ───────────────────────────────────────────
                    const Text(
                      "Your documents are under review. We'll notify you once verification is complete.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── Info card ──────────────────────────────────────────
                    const _InfoCard(
                      text:
                          'Large-volume orders (>100 m³) require verified KYC.',
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom actions ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                0,
                AppSpacing.xxl,
                bottomInset > 0 ? bottomInset + AppSpacing.xs : AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppGradientButton(
                    label: 'Go to Home',
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  AppOutlineButton(
                    label: 'View Uploaded Documents',
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.kycVerification),
                    icon: Icons.description_outlined,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Contact Support ──────────────────────────────────────
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Contact Support',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pending pill badge ────────────────────────────────────────────────────────
class _PendingBadge extends StatelessWidget {
  const _PendingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: BoxDecoration(
        color: _badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Pending',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String text;
  const _InfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 22, color: _infoIcon),
          const SizedBox(width: AppSpacing.md),
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
