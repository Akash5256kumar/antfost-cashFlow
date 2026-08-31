import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class SiteCheckpointScreen extends StatefulWidget {
  const SiteCheckpointScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
  });

  final String orderId;
  final String projectName;

  @override
  State<SiteCheckpointScreen> createState() => _SiteCheckpointScreenState();
}

class _SiteCheckpointScreenState extends State<SiteCheckpointScreen> {
  static const _resources = [
    (
      title: 'Pump', 
      sub: 'Ready', 
      pill: 'At Site',
      color: Color(0xFF4F46E5), 
      bg: Color(0xFFEEF2FF),
      num: '',
    ),
    (
      title: 'Truck 01', 
      sub: '03:42 remaining', 
      pill: 'At Checkpoint',
      color: Color(0xFF4F46E5), 
      bg: Color(0xFFEEF2FF),
      num: '1',
    ),
    (
      title: 'Truck 02', 
      sub: '05 min away', 
      pill: 'Approaching',
      color: Color(0xFF10B981), 
      bg: Color(0xFFD1FAE5),
      num: '2',
    ),
    (
      title: 'Truck 03', 
      sub: '12 min away', 
      pill: 'Following',
      color: Color(0xFFF59E0B), 
      bg: Color(0xFFFEF3C7),
      num: '3',
    ),
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
              child: Text('Site Checkpoint', style: AppTextStyles.screenTitle(context).copyWith(color: const Color(0xFF1E1B4B))),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text('${widget.orderId} · ${widget.projectName}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ),
            const SizedBox(height: 24),
            
            // Map Image (Edge to Edge)
            Image.asset(
              AppAssets.artCheckpointMap,
              width: double.infinity,
              height: 320,
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
                    const SizedBox(height: 24),

                    const Text('Pump + Trucks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                    const SizedBox(height: 16),

                    // Resources List
                    ..._resources.map((res) {
                      final isPump = res.num.isEmpty;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC), // Light grey background for each row
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            children: [
                              // Number Badge (or empty space for pump)
                              if (!isPump)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(color: res.bg, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(res.num, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: res.color)),
                                ),
                              if (!isPump) const SizedBox(width: 12),
                              
                              // Image
                              Image.asset(
                                AppAssets.artHeroTruck, 
                                width: 40, 
                                height: 40, 
                                fit: BoxFit.contain
                              ),
                              const SizedBox(width: 12),
                              
                              // Text Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(res.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                                    const SizedBox(height: 2),
                                    Text(res.sub, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isPump ? res.color : (res.color == const Color(0xFF4F46E5) ? res.color : res.color))), 
                                  ],
                                ),
                              ),
                              
                              // Status Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: res.bg, borderRadius: BorderRadius.circular(999)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(width: 6, height: 6, decoration: BoxDecoration(color: res.color, shape: BoxShape.circle)),
                                    const SizedBox(width: 6),
                                    Text(res.pill, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: res.color)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 24),
                    
                    // Horizontal Timeline
                    Row(
                      children: [
                        // Node 1: Arrived
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(color: Color(0xFF4F46E5), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(Icons.check, size: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            const Text('Arrived', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                        // Line 1
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Container(height: 2, color: const Color(0xFF4F46E5)),
                          ),
                        ),
                        // Node 2: Site Checkpoint
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(color: Color(0xFF4F46E5), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Text('2', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            const Text('Site Checkpoint', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
                          ],
                        ),
                        // Line 2
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: CustomPaint(
                              painter: _DashedLinePainter(color: const Color(0xFFCBD5E1)),
                              size: const Size(double.infinity, 2),
                            ),
                          ),
                        ),
                        // Node 3: Pouring
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCBD5E1), width: 2)),
                              alignment: Alignment.center,
                              child: const Text('3', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                            ),
                            const SizedBox(height: 8),
                            const Text('Pouring', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Notice Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF64748B)),
                          SizedBox(width: 8),
                          Text('Site access confirmation in progress', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    PrimaryButton(
                      arrow: true,
                      label: 'View Resource Sequence',
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.pouring),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 20),
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

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke;
    
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
