import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({
    super.key,
    this.orderId = 'AF-2048',
    this.driverName = 'Abdul Rahman',
    this.truckId = 'TR-4022',
    this.mixType = 'C25/30 Standard',
    this.quantity = '50 m³',
    this.etaMinutes = 12,
    this.destinationArea = 'DUBAI MARINA',
  });

  final String orderId;
  final String driverName;
  final String truckId;
  final String mixType;
  final String quantity;
  final int etaMinutes;
  final String destinationArea;

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  static const _trucks = [
    ('01', 'Arrived', Color(0xFF4F46E5), '08:56'),
    ('02', 'Approaching', Color(0xFF4F46E5), '05 min'),
    ('03', 'Following', Color(0xFF4F46E5), '12 min'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
        ),
        title: SvgPicture.asset(AppAssets.antfostLogo, height: 26),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Text('Live Delivery', style: AppTextStyles.screenTitle(context).copyWith(color: const Color(0xFF1E1B4B))),
            ),
            const SizedBox(height: 24),
            
            // First Card: Order info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(AppAssets.orderThumbPalm, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.orderId} · Palm Jumeirah Villa',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Text(
                                'Arrived at Site',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5)),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.check_circle, size: 16, color: Color(0xFF4F46E5)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF4F46E5)),
                          SizedBox(width: 6),
                          Text('Trucks Only', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Second Card: Location Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF4F46E5)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Main Villa Entrance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Map Image (Edge to Edge)
            Image.asset(
              AppAssets.artTrackingMap,
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            ),
            
            // Bottom Sheet Section
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Trucks Only header
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.local_shipping_outlined, size: 24, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trucks Only', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                              SizedBox(height: 2),
                              Text('3 trucks delivering concrete', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Truck list
                    ..._trucks.map((t) {
                      final isArrived = t.$2 == 'Arrived';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.siteCheckpoint),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(AppAssets.artHeroTruck, fit: BoxFit.contain),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Truck ${t.$1}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                                      const SizedBox(height: 4),
                                      const Text('7 m³ · C30/37', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                
                                // Status Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(999)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(width: 6, height: 6, decoration: BoxDecoration(color: t.$3, shape: BoxShape.circle)),
                                      const SizedBox(width: 6),
                                      Text(t.$2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.$3)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Time Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(999)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 14, color: t.$3),
                                      const SizedBox(width: 4),
                                      Text(t.$4, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.$3)),
                                    ],
                                  ),
                                ),
                                
                                if (!isArrived) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                                ]
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 8),
                    PrimaryButton(
                      arrow: true,
                      label: 'View Site Progress',
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.siteCheckpoint),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
