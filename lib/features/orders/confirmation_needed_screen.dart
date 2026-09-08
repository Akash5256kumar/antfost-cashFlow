import 'package:flutter/material.dart';
import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import 'schedule_proposed_screen.dart';

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
      appBar: AppBrandHeader(
        showBack: true,
        onBellTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      bottomNavigationBar: AppTabControllerScope(
        currentTab: AppTab.home,
        onSelectTab: (index) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppTab.values[index].routeName,
            (route) => false,
          );
        },
        child: const AppTabBottomNavBar(currentTab: AppTab.home),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text('Confirmation Needed', style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 26, color: const Color(0xFF1E1B4B))),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_bottom_rounded, size: 14, color: Color(0xFFEA580C)),
                    const SizedBox(width: 6),
                    const Text('Confirmation needed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFEA580C))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('$orderRef • $projectName', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 24),
            
            // The Table
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Col 1
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          const SizedBox(height: 52), // Header space
                          const Divider(height: 1, color: AppColors.cardBorder),
                          const _SideHeaderCell(icon: Icons.access_time_rounded, text: 'Shift'),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          const _SideHeaderCell(icon: Icons.local_shipping_outlined, text: 'Services'),
                        ],
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    // Col 2
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: const Color(0xFFF8FAFC),
                        child: Column(
                          children: [
                            const _HeaderCell('You Requested'),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            const _ValueCell('Morning\n06:00 - 12:00'),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            const _ValueCell('Medium Pump\n43–52 m'),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    // Col 3
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const _HeaderCell('ANTFAST Proposal', isBlue: true),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          const _ValueCell('Midday\n12:00 - 16:00'),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          const _ValueCell('Medium Pump\n43–52 m'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Estimates
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  const _EstimateRow(label: 'Estimated starting time', value: '8:30 AM'),
                  const Divider(height: 1, color: AppColors.cardBorder, indent: 16, endIndent: 16),
                  const _EstimateRow(label: 'Estimated completion', value: 'About 2 hr 30 min'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Shield Info Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC), // slightly grey/blue tint like in image
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'This sequence provides a steadier concrete flow for your selected volume and site access.',
                              style: TextStyle(fontSize: 12.5, color: Color(0xFF1E1B4B), height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppIllustrationImage(
                    asset: AppAssets.artHeroTruck,
                    height: 100,
                    width: 120,
                    borderRadius: 0,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bottom info box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 18, color: Color(0xFF64748B)),
                  const SizedBox(width: 12),
                  const Text('120 m³ • C30/37 • Main Villa Entrance', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Buttons
            PrimaryButton(
              arrow: true,
              label: 'Accept Proposal',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const ScheduleProposedScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              label: 'Request Change',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SideHeaderCell extends StatelessWidget {
  const _SideHeaderCell({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.isBlue = false});
  final String text;
  final bool isBlue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBlue ? FontWeight.w600 : FontWeight.w400,
            color: isBlue ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1B4B),
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _EstimateRow extends StatelessWidget {
  const _EstimateRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.access_time_rounded, size: 20, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4F46E5), fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
