import 'dart:ui';
import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_outline_button.dart';

class UploadPaymentProofScreen extends StatefulWidget {
  const UploadPaymentProofScreen({super.key, this.totalAmount = 29820.00});

  final double totalAmount;

  @override
  State<UploadPaymentProofScreen> createState() =>
      _UploadPaymentProofScreenState();
}

class _UploadPaymentProofScreenState extends State<UploadPaymentProofScreen> {
  bool _uploaded = false;

  static const _bankDetails = [
    ('Bank', 'ANTFAST Bank', false),
    ('IBAN', 'AE•• •••• •••• 2086', true),
    ('Reference', 'AF-260803-014', true),
  ];

  @override
  Widget build(BuildContext context) {
    final amount = 'AED ${widget.totalAmount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppBrandHeader(showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.scaled(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.scaledV(16)),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Image in background (right aligned)
                        Positioned(
                          top: 0,
                          right: -context.scaled(30), // Push slightly out of bounds
                          child: Opacity(
                            opacity: 0.9,
                            child: Image.asset(
                              AppAssets.artBankTransfer,
                              height: context.scaled(180),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Content on left
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Payment Proof',
                              style: TextStyle(
                                fontSize: context.scaled(22),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E1B4B),
                              ),
                            ),
                            SizedBox(height: context.scaledV(12)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaled(12),
                                vertical: context.scaledV(6),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(context.scaled(16)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.account_balance_outlined,
                                    size: context.scaled(14),
                                    color: const Color(0xFF8B5CF6),
                                  ),
                                  SizedBox(width: context.scaled(6)),
                                  Text(
                                    'Bank Transfer',
                                    style: TextStyle(
                                      fontSize: context.scaled(12),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: context.scaledV(24)),
                            
                            Text(
                              'Amount transferred',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: context.scaledV(4)),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'AED ',
                                    style: TextStyle(
                                      fontSize: context.scaled(16),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E1B4B),
                                    ),
                                  ),
                                  TextSpan(
                                    text: amount.replaceAll('AED ', ''),
                                    style: TextStyle(
                                      fontSize: context.scaled(24),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E1B4B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: context.scaledV(24)),
                    
                    // Transfer Details Card
                    Container(
                      padding: EdgeInsets.all(context.scaled(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transfer Details',
                            style: TextStyle(
                              fontSize: context.scaled(15),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1B4B),
                            ),
                          ),
                          SizedBox(height: context.scaledV(16)),
                          ..._bankDetails.map((detail) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: context.scaledV(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    detail.$1,
                                    style: TextStyle(
                                      fontSize: context.scaled(13),
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        detail.$2,
                                        style: TextStyle(
                                          fontSize: context.scaled(13),
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E1B4B),
                                        ),
                                      ),
                                      if (detail.$3) ...[
                                        SizedBox(width: context.scaled(8)),
                                        Icon(
                                          Icons.copy_outlined,
                                          size: context.scaled(16),
                                          color: const Color(0xFF64748B),
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: context.scaledV(16)),
                    
                    // Upload Payment Proof Card
                    Container(
                      padding: EdgeInsets.all(context.scaled(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(16)),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload Payment Proof',
                            style: TextStyle(
                              fontSize: context.scaled(15),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1B4B),
                            ),
                          ),
                          SizedBox(height: context.scaledV(16)),
                          GestureDetector(
                            onTap: () => setState(() => _uploaded = true),
                            child: CustomPaint(
                              painter: _DottedBorderPainter(
                                color: const Color(0xFF8B5CF6),
                                strokeWidth: 1.5,
                                radius: context.scaled(12),
                                dashWidth: 6,
                                dashSpace: 4,
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: context.scaledV(24)),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F3FF).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(context.scaled(12)),
                                ),
                                child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(context.scaled(12)),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAE5FF),
                                      borderRadius: BorderRadius.circular(context.scaled(12)),
                                    ),
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: context.scaled(24),
                                      color: const Color(0xFF4F46E5),
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(12)),
                                  Text(
                                    'Attach receipt or transfer screenshot',
                                    style: TextStyle(
                                      fontSize: context.scaled(13),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E1B4B),
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(4)),
                                  Text(
                                    'JPG, PNG or PDF • Max 10 MB',
                                    style: TextStyle(
                                      fontSize: context.scaled(11),
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(8)),
                                  Text(
                                    'Choose File',
                                    style: TextStyle(
                                      fontSize: context.scaled(13),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4F46E5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: context.scaledV(16)),
                    
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(12),
                        vertical: context.scaledV(12),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(context.scaled(8)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: context.scaled(16),
                            color: const Color(0xFFD97706),
                          ),
                          SizedBox(width: context.scaled(8)),
                          Expanded(
                            child: Text(
                              'Payment remains pending until Finance verifies the attachment.',
                              style: TextStyle(
                                fontSize: context.scaled(11),
                                color: const Color(0xFFD97706),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(32)),
                    
                    // Bottom buttons
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        context.scaled(16),
                        0,
                        MediaQuery.paddingOf(context).bottom + context.scaled(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: 'Submit Payment Proof',
                            arrow: true,
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.paymentSuccess);
                            },
                          ),
                          SizedBox(height: context.scaledV(12)),
                          AppOutlineButton(
                            label: 'Change Method',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
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

class _DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  _DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dashPath = Path();
    for (final PathMetric measurePath in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(_DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}

