import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';

/// Ported from the new Figma design's `screens/ConfirmationNeeded.tsx` —
/// shown when ANTFAST proposes a different schedule/service mix than what
/// was requested, part of the granular delivery-tracking flow.
class ConfirmationNeededScreen extends StatelessWidget {
  const ConfirmationNeededScreen({
    super.key,
    this.orderRef = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
  });

  final String orderRef;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Confirmation Needed', style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_bottom_rounded, size: 14, color: Color(0xFFEA580C)),
                    const SizedBox(width: 6),
                    const Text('Confirmation needed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFEA580C))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('$orderRef · $projectName', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text('You Requested', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'ANTFAST Proposal',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8B5CF6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const _CompareRow(icon: Icons.access_time_rounded, title: 'Shift', yours: 'Morning', theirs: 'Morning'),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const _CompareRow(icon: Icons.local_shipping_outlined, title: 'Services', yours: 'Medium Pump\n43-52 m', theirs: 'Medium Pump\n43-52 m'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _EstimateCard(label: 'Estimated starting time', value: '8:30 AM'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _EstimateCard(label: 'Estimated completion', value: 'About 2 hr 30 min'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This sequence provides a steadier concrete flow for your selected volume and site access.',
                              style: AppTextStyles.cardSubtitle(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppIllustrationImage(
                    asset: AppAssets.artHeroTruck,
                    height: 90,
                    width: 110,
                    borderRadius: 0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Text('120 m³ · C30/37 · Main Villa Entrance', style: AppTextStyles.cardSubtitle(context)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              arrow: true,
              label: 'Accept Proposal',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.scheduleProposed),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              label: 'Request Change',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.icon, required this.title, required this.yours, required this.theirs});
  final IconData icon;
  final String title;
  final String yours;
  final String theirs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(yours, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color(0xFF1E1B4B))),
          ),
          Expanded(
            flex: 3,
            child: Text(
              theirs,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4F46E5), fontSize: 16)),
        ],
      ),
    );
  }
}
