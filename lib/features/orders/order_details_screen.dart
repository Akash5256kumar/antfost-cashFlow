import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
  });

  final String orderId;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E1B4B)),
        ),
        title: SvgPicture.asset(AppAssets.antfostLogo, height: 26),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
          ),
        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF), // Light blue
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 8),
                    const Text('Loading started', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Order Details', textAlign: TextAlign.center, style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 26, color: const Color(0xFF1E1B4B))),
            const SizedBox(height: 24),
            
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
                    decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.description_outlined, size: 20, color: Color(0xFF4F46E5)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text('Order $orderId · $projectName', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Hero Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                AppAssets.artLoadingGauge,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            
            // Timeline Container
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildTimelineItem(
                    title: 'Loading started',
                    subtitle: 'In progress',
                    isCompleted: true,
                    isLast: false,
                    isCurrent: true,
                  ),
                  _buildTimelineItem(
                    title: 'Loading completed',
                    subtitle: "We'll notify you when loading is complete",
                    isCompleted: false,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: 'On the way',
                    subtitle: 'Tracking begins after departure',
                    isCompleted: false,
                    isLast: true,
                  ),
                ],
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
                      color: Color(0xFFEEF2FF),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFF4F46E5)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your first delivery resource is being loaded.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
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
                      color: Color(0xFFEEF2FF),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.precision_manufacturing_rounded, size: 20, color: Color(0xFF4F46E5)),
                  ),
                  const SizedBox(width: 14),
                  const Text('Pump + 8 Trucks', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.liveTracking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('View Order Status'),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: const Color(0xFF4F46E5),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                child: const Text('Back to Home'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 64),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
    bool isCurrent = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF4F46E5) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: isCompleted ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w600, color: const Color(0xFF1E1B4B))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: isCurrent ? const Color(0xFF4F46E5) : const Color(0xFF64748B), fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
