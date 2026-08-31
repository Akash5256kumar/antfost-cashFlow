import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../core/widgets/primary_button.dart';

class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Centred status content ───────────────────────────────────
            // LayoutBuilder + a min-height ConstrainedBox keeps this block
            // vertically centred exactly as before when it fits, but lets
            // it scroll instead of overflowing on smaller screens or with
            // larger system font sizes.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── Verification status illustration ────────────────────
                          SvgPicture.asset(
                            AppAssets.process,
                            width: context.scaled(88),
                            height: context.scaled(88),
                          ),

                          SizedBox(height: context.scaledV(22)),

                          // ── Pending badge ──────────────────────────────────────
                          const _PendingBadge(),

                          SizedBox(height: context.scaledV(28)),

                          // ── Title ──────────────────────────────────────────────
                          Text(
                            'Verification Pending',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.scaled(26),
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),

                          SizedBox(height: context.scaledV(12)),

                          // ── Subtitle ───────────────────────────────────────────
                          Text(
                            "Your documents are under review. We'll notify you once verification is complete.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.scaled(15),
                              color: AppColors.textSecondary,
                              height: 1.55,
                            ),
                          ),

                          SizedBox(height: context.scaledV(28)),

                          // ── Info card ──────────────────────────────────────────
                          const _InfoCard(
                            text:
                                'Large-volume orders (>100 m³) require verified KYC.',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Bottom actions ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xxl(context),
                0,
                AppSpacing.xxl(context),
                AppSpacing.xl(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    label: 'Go to Home',
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                  ),

                  SizedBox(height: context.scaledV(12)),

                  AppOutlineButton(
                    label: 'View Uploaded Documents',
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.kycVerification),
                    icon: Icons.description_outlined,
                  ),

                  SizedBox(height: context.scaledV(12)),

                  // ── Contact Support ──────────────────────────────────────
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: context.scaled(18),
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: context.scaled(8)),
                        Text(
                          'Contact Support',
                          style: TextStyle(
                            fontSize: context.scaled(15),
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
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(20),
        vertical: context.scaled(7),
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(context.scaled(20)),
      ),
      child: Text(
        'Pending',
        style: TextStyle(
          fontSize: context.scaled(14),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg(context),
        vertical: AppSpacing.md(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.lg(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: context.scaled(22),
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.md(context)),
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
