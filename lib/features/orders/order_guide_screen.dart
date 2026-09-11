import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';

const Color _pageBg = AppColors.background;

class _GuideStep {
  final String title;
  final String description;
  const _GuideStep(this.title, this.description);
}

const List<_GuideStep> _steps = [
  _GuideStep('Select Site', 'Choose a saved project site or add a new one.'),
  _GuideStep('Pick Product', 'Choose your concrete mix and required services.'),
  _GuideStep(
    'Enter Quantity',
    'Specify total volume and pour rate requirements.',
  ),
  _GuideStep('Set Schedule', 'Pick your preferred date and time shift.'),
  _GuideStep('Confirm Details', 'Review order summary and pricing breakdown.'),
  _GuideStep('Place Order', 'Pay via wallet or card to confirm booking.'),
];

/// Shown before the new-cash-order flow starts — a quick "how it works"
/// walkthrough so first-time orderers know what to expect.
class OrderGuideScreen extends StatelessWidget {
  const OrderGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header + hero image ─────────────────────────────────────
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Concrete',
                      style: TextStyle(
                        fontSize: context.scaled(28),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.scaledV(6)),
                    Text(
                      'Get instant pricing and fast delivery across UAE',
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(context.scaled(16)),
                      child: SvgEmbeddedRasterImage(
                        assetPath: AppAssets.guideBg,
                        width: double.infinity,
                        height: context.scaled(180),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              // ── How it works ────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: _pageBg,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg(context),
                  AppSpacing.lg(context),
                  AppSpacing.lg(context),
                  AppSpacing.xxl(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works',
                      style: TextStyle(
                        fontSize: context.scaled(20),
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    for (var i = 0; i < _steps.length; i++) ...[
                      _StepCard(number: i + 1, step: _steps[i]),
                      if (i < _steps.length - 1)
                        SizedBox(height: context.scaledV(12)),
                    ],
                    SizedBox(height: context.scaledV(24)),
                    AppGradientButton(
                      label: 'Start New Order',
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.addNewProject),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int number;
  final _GuideStep step;

  const _StepCard({required this.number, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg(context)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.scaled(32),
            height: context.scaled(32),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: context.scaled(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: context.scaledV(3)),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: context.scaled(13),
                    color: AppColors.textSecondary,
                    height: 1.4,
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
