import 'package:flutter/material.dart';
import '../../core/widgets/app_headers.dart';

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
    this.quantity = '120 m³',
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
      appBar: AppBrandHeader(
        showBack: true,
        showChat: true,
        onChatTap: () => Navigator.of(context).pushNamed(AppRoutes.orderChat),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          Center(
            child: Text('Live Delivery', style: AppTextStyles.screenTitle(context).copyWith(color: const Color(0xFF1E1B4B))),
          ),
          const SizedBox(height: 12),
          
          // First Card: Order info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(AppAssets.orderThumbPalm, width: 44, height: 44, fit: BoxFit.cover),
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
                            Expanded(
                              child: Text(
                                'Arrived at Site',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.check_circle, size: 14, color: Color(0xFF4F46E5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 12, color: const Color(0xFF4F46E5)),
                        const SizedBox(width: 4),
                        Text('Trucks Only', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Map Section with floating Location Card and Bottom Sheet
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Map Section (Takes remaining space ABOVE bottom sheet)
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AppAssets.artVillaRouteMap,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                          // Floating Location Info
                          Positioned(
                            top: 12,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF4F46E5)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Main Villa Entrance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Fixed Bottom Sheet Section
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.65, // Limit bottom sheet height so map always has space
                      ),
                      child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.paddingOf(context).bottom + 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Trucks Only header
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.local_shipping_outlined, size: 18, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trucks Only', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                              const SizedBox(height: 2),
                              const Text('3 trucks delivering concrete', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Truck list
                    ..._trucks.map((t) {
                      final isArrived = t.$2 == 'Arrived';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.siteCheckpoint),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(AppAssets.mixThumb15, fit: BoxFit.contain),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Truck ${t.$1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                                      const SizedBox(height: 2),
                                      const Text('7 m³ · C30/37', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                
                                // Status Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(999)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(width: 6, height: 6, decoration: BoxDecoration(color: t.$3, shape: BoxShape.circle)),
                                      const SizedBox(width: 4),
                                      Text(t.$2, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: t.$3)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),

                                // Time Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 14, color: t.$3),
                                      const SizedBox(width: 4),
                                      Text(t.$4, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: t.$3)),
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
                    
                    const SizedBox(height: 4),
                    PrimaryButton(
                      arrow: true,
                      label: 'View Site Progress',
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.siteCheckpoint),
                    ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    ),
                  ],
                );
          },
        ),
      ),
        ],
      ),
    );
  }
}
