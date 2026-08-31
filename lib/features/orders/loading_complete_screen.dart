import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';

/// Ported from the new Figma design's `screens/LoadingComplete.tsx` — first
/// step of the granular delivery-tracking flow (Loading Complete → Live
/// Tracking → Site Checkpoint → Pouring → Assigned Resources → Delivery
/// Complete → Rate Delivery).
class LoadingCompleteScreen extends StatelessWidget {
  const LoadingCompleteScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
  });

  final String orderId;
  final String projectName;

  static const _steps = [
    ('Scheduled', 'Today, 8:00 AM', true, false),
    ('Loading completed', 'Today, 10:35 AM', true, false),
    ('On the way', 'Preparing departure', false, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBrandHeader(
        onBellTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Top Check Badge
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E8FF), // Light purple
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Color(0xFF8B5CF6), size: 24),
              ),
            ),
            const SizedBox(height: 16),
            Text('Loading Completed', textAlign: TextAlign.center, style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 26)),
            const SizedBox(height: 12),
            
            // Status Pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF), // Light purple
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 8),
                    const Text('Preparing departure', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Hero Image
            AppIllustrationImage(
              asset: AppAssets.figmaPlant,
              height: 200,
              borderRadius: 16,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Order Ref box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.description_outlined, size: 20, color: Color(0xFF8B5CF6)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text('Order $orderId · $projectName', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Timeline Container
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: List.generate(_steps.length, (i) {
                  final (label, sub, done, preparing) = _steps[i];
                  final isLast = i == _steps.length - 1;
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 24,
                          child: Column(
                            children: [
                              if (i > 0)
                                Container(
                                  width: 2,
                                  height: 8,
                                  color: done || preparing ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                                )
                              else
                                const SizedBox(height: 8),

                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: done ? const Color(0xFF4F46E5) : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: done ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                              ),

                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: done ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24.0, top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(label, style: TextStyle(fontSize: 14, fontWeight: done ? FontWeight.w700 : FontWeight.w600, color: const Color(0xFF1E1B4B))),
                                const SizedBox(height: 4),
                                Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Notice Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E8FF),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFF8B5CF6)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your first delivery resource is preparing to depart.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                        SizedBox(height: 6),
                        Text(
                          'Live tracking appears after departure and initial movement toward your site.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Assigned resource card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E8FF),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.precision_manufacturing_rounded, size: 20, color: Color(0xFF8B5CF6)),
                  ),
                  const SizedBox(width: 14),
                  const Text('Pump + 8 Trucks', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            PrimaryButton(
              label: 'View Order Status', // Arrow removed
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.liveTracking),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              variant: PrimaryButtonVariant.ghost, // Changed to PrimaryButton ghost variant
              label: 'Back to Home',
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false),
            ),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 64),
          ],
        ),
      ),
    );
  }
}
