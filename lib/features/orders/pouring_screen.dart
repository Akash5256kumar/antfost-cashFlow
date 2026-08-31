import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';

class PouringScreen extends StatefulWidget {
  const PouringScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
  });

  final String orderId;
  final String projectName;

  @override
  State<PouringScreen> createState() => _PouringScreenState();
}

class _PouringScreenState extends State<PouringScreen> {
  static const _resources = [
    (
      title: 'Pump', 
      sub: 'Arrived', 
      time: '',
      pill: 'In Use',
      isCompleted: true,
      color: Color(0xFF4F46E5), 
      num: '',
      isPump: true,
    ),
    (
      title: 'Truck 01', 
      sub: 'Supplying Pump', 
      time: '18:24',
      pill: '',
      isCompleted: true,
      color: Color(0xFF4F46E5), 
      num: '2', 
      isPump: false,
    ),
    (
      title: 'Truck 02', 
      sub: 'Site Checkpoint', 
      time: '02:10',
      pill: '',
      isCompleted: false,
      color: Color(0xFF4F46E5), 
      num: '3',
      isPump: false,
    ),
    (
      title: 'Truck 03', 
      sub: 'Approaching Site', 
      time: '08 min',
      pill: '',
      isCompleted: false,
      color: Color(0xFFF59E0B), 
      num: '4',
      isPump: false,
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
              child: Text('Pouring', style: AppTextStyles.screenTitle(context).copyWith(color: const Color(0xFF1E1B4B))),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text('${widget.orderId} · ${widget.projectName}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ),
            const SizedBox(height: 24),
            
            // Map Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppAssets.artPouringMap,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Bottom Section
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
                    const SizedBox(height: 20),

                    // Vertical Timeline List
                    Stack(
                      children: [
                        // Vertical dotted line connecting the nodes
                        Positioned(
                          left: 11,
                          top: 24,
                          bottom: 40,
                          child: CustomPaint(
                            painter: _VerticalDashedLinePainter(color: const Color(0xFFCBD5E1)),
                            size: const Size(2, double.infinity),
                          ),
                        ),
                        Column(
                          children: _resources.map((res) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Node Icon
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: res.isCompleted ? const Color(0xFFEEF2FF) : res.color.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: res.isCompleted
                                        ? const Icon(Icons.check, size: 14, color: Color(0xFF4F46E5))
                                        : Text(res.num, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: res.color)),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Truck/Pump Image
                                  Image.asset(
                                    res.isPump ? AppAssets.artHeroTruck : AppAssets.artHeroTruck, // using truck as placeholder for pump too
                                    width: 40,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Texts
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(res.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                                        const SizedBox(height: 2),
                                        Text(res.sub, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: res.color)),
                                      ],
                                    ),
                                  ),
                                  
                                  // Right Widget (Pill or Time)
                                  if (res.pill.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(999)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF4F46E5), shape: BoxShape.circle)),
                                          const SizedBox(width: 6),
                                          Text(res.pill, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
                                        ],
                                      ),
                                    )
                                  else if (res.time.isNotEmpty)
                                    Text(res.time, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: res.color)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),

                    // Notice Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF4F46E5)),
                          SizedBox(width: 8),
                          Text('Expected pour window · 20–35 min', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF4F46E5))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    PrimaryButton(
                      arrow: true,
                      label: 'View Resource Sequence',
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.assignedResources),
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

class _VerticalDashedLinePainter extends CustomPainter {
  final Color color;
  _VerticalDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..style = PaintingStyle.stroke;
    
    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;
    
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
