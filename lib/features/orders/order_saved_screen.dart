import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';

/// Ported from the new Figma design's `screens/OrderSaved.tsx` — shown
/// when an order is saved while business KYC is still under review
/// (payment isn't available until approval).
class OrderSavedScreen extends StatelessWidget {
  const OrderSavedScreen({
    super.key,
    this.projectName = 'Palm Jumeirah Villa',
    this.quantity = 120,
    this.mixCode = 'C30/37',
  });

  final String projectName;
  final int quantity;
  final String mixCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Order Saved',
              textAlign: TextAlign.center,
              style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('Verification in review', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: -20),
              child: AppIllustrationImage(
                asset: AppAssets.artKycShield,
                height: 200,
                borderRadius: 0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your order has been saved.',
              textAlign: TextAlign.center,
              style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              'Payment will be available after ANTFAST approves your account.',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardSubtitle(context),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      AppAssets.photoForLocation(projectName) ?? AppAssets.figmaVilla,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$projectName · $quantity m³ · $mixCode',
                          style: AppTextStyles.cardTitle(context).copyWith(fontSize: 13.5),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Waiting for KYC Approval',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              arrow: true,
              label: 'View Saved Order',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.myOrders),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              label: 'Back to Home',
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
