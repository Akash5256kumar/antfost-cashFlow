import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/primary_button.dart';

/// Customer-facing business verification status opened from Home and Profile.
class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          'Verification Status',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.scaled(20)),
          child: Column(
            children: [
              Container(
                width: context.scaled(72),
                height: context.scaled(72),
                decoration: const BoxDecoration(
                  color: AppColors.warningContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.warning,
                  size: context.scaled(34),
                ),
              ),
              SizedBox(height: context.scaledV(20)),
              Text(
                'Verification under review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.scaled(22),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.scaledV(8)),
              Text(
                'Your company documents have been submitted. Payment will be available after approval.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.scaled(13),
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              SizedBox(height: context.scaledV(28)),
              _StatusRow(
                icon: Icons.business_rounded,
                title: 'Company details',
                status: 'Submitted',
              ),
              _StatusRow(
                icon: Icons.description_outlined,
                title: 'Business documents',
                status: 'Under review',
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Back to Home',
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.title,
    required this.status,
  });

  final IconData icon;
  final String title;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.scaledV(12)),
      padding: EdgeInsets.all(context.scaled(14)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.scaled(14)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: context.scaled(12)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: context.scaled(12),
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
