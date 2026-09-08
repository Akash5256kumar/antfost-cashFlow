import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import 'order_details_screen.dart';

/// Ported from the new Figma design's `screens/DeliveryScheduled.tsx`.
class ScheduleProposedScreen extends StatefulWidget {
  const ScheduleProposedScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.proposedDate = 'Tuesday · 12 August',
    this.proposedShift = '08:30',
    this.quantityMix = '120 m³ · C30/37',
    this.deliveryInterval = '12 min interval',
    this.equipment = 'Pump + Technician',
    this.location = 'Main Villa Entrance',
    this.supplyWindow = '08:30–11:00',
  });

  final String orderId;
  final String proposedDate;
  final String proposedShift;
  final String quantityMix;
  final String deliveryInterval;
  final String equipment;
  final String location;
  final String supplyWindow;

  @override
  State<ScheduleProposedScreen> createState() => _ScheduleProposedScreenState();
}

class _ScheduleProposedScreenState extends State<ScheduleProposedScreen> {
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
            Text('Delivery Scheduled', style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF8B5CF6)),
                    SizedBox(width: 6),
                    Text('Scheduled', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            AppIllustrationImage(
              asset: AppAssets.artVillaPumpHero,
              height: 180,
              borderRadius: 16,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.proposedDate, style: AppTextStyles.cardSubtitle(context)),
                      Text(
                        widget.proposedShift,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _DetailRow(icon: Icons.layers_rounded, value: widget.quantityMix),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _DetailRow(icon: Icons.access_time_rounded, value: widget.deliveryInterval),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _DetailRow(icon: Icons.engineering_rounded, value: widget.equipment),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _DetailRow(icon: Icons.location_on_outlined, value: widget.location),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Supply Window', style: AppTextStyles.cardSubtitle(context)),
                        Text('08:30–11:00', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text(
                          'Updates automatically if the delivery plan changes',
                          style: AppTextStyles.cardSubtitle(context).copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.notifications_none_rounded, size: 16, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "We'll notify you when loading is completed.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              arrow: true,
              label: 'View Order Details',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(
                    orderId: widget.orderId,
                    projectName: widget.location,
                    quantity: int.tryParse(widget.quantityMix.split(' ').first) ?? 120,
                    mixCode: widget.quantityMix.contains('·') ? widget.quantityMix.split('·').last.trim() : 'C30/37',
                    resources: widget.equipment,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              icon: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
              label: 'Add to Calendar',
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8B5CF6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: Color(0xFF1E1B4B)),
            ),
          ),
        ],
      ),
    );
  }
}
