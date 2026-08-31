import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = AppColors.textPrimary;
const Color _textGrey = AppColors.textSecondary;
const Color _fieldBorder = AppColors.cardBorder;
const Color _bodyBg = AppColors.background;
const Color _inkColor = Color(0xFF4A6FA5);

// ── Signature data model ──────────────────────────────────────────────────────
class _SignatureItem {
  final String name;
  final String role;
  final String dateTime;

  const _SignatureItem({
    required this.name,
    required this.role,
    required this.dateTime,
  });
}

const _signatures = [
  _SignatureItem(
    name: 'Ahmed Al Mansouri',
    role: 'Plant Supervisor',
    dateTime: '9 Feb 2026, 01:35 PM',
  ),
  _SignatureItem(
    name: 'Sara Hassan',
    role: 'QC Officer',
    dateTime: '9 Feb 2026, 02:00 PM',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class SignaturesScreen extends StatelessWidget {
  const SignaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            const _SignaturesAppBar(),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.scaled(16),
                  context.scaled(16),
                  context.scaled(16),
                  context.scaled(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Signatures',
                      style: TextStyle(
                        fontSize: context.scaled(18),
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    ..._signatures.map(
                      (s) => Padding(
                        padding: EdgeInsets.only(bottom: context.scaled(16)),
                        child: _SignatureCard(item: s),
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

// ── App bar ───────────────────────────────────────────────────────────────────
class _SignaturesAppBar extends StatelessWidget {
  const _SignaturesAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaled(8),
        context.scaled(16),
        context.scaled(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.scaled(44),
            height: context.scaled(44),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back_rounded, size: context.scaled(24)),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          SizedBox(width: context.scaled(4)),
          Text(
            'Signatures',
            style: TextStyle(
              fontSize: context.scaled(22),
              fontWeight: FontWeight.w600,
              color: _textDark,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Signature card ────────────────────────────────────────────────────────────
class _SignatureCard extends StatelessWidget {
  const _SignatureCard({required this.item});
  final _SignatureItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scaled(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: context.scaled(180),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.scaled(12)),
              border: Border.all(color: _fieldBorder),
            ),
            child: const CustomPaint(
              size: Size.infinite,
              painter: _SignaturePainter(),
            ),
          ),
          SizedBox(height: context.scaledV(12)),
          Text(
            item.name,
            style: TextStyle(
              fontSize: context.scaled(16),
              fontWeight: FontWeight.w700,
              color: _textDark,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.scaledV(2)),
          Text(
            item.role,
            style: TextStyle(
              fontSize: context.scaled(14),
              color: _textGrey,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.scaledV(2)),
          Text(
            item.dateTime,
            style: TextStyle(
              fontSize: context.scaled(13),
              color: _textGrey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Signature painter ─────────────────────────────────────────────────────────
//
// Draws a stylised cursive signature squiggle — a flat lead-in stroke
// followed by a couple of looping, tapered peaks — in a muted ink-blue.
class _SignaturePainter extends CustomPainter {
  const _SignaturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    final paint = Paint()
      ..color = _inkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      // Flat lead-in stroke from the left.
      ..moveTo(cx - w * 0.28, cy + h * 0.05)
      ..lineTo(cx - w * 0.02, cy - h * 0.02)
      // First loop.
      ..cubicTo(
        cx - w * 0.01,
        cy - h * 0.28,
        cx + w * 0.05,
        cy - h * 0.28,
        cx + w * 0.04,
        cy - h * 0.06,
      )
      ..cubicTo(
        cx + w * 0.03,
        cy + h * 0.16,
        cx + w * 0.10,
        cy + h * 0.16,
        cx + w * 0.11,
        cy - h * 0.02,
      )
      // Tall rising peak.
      ..cubicTo(
        cx + w * 0.12,
        cy - h * 0.22,
        cx + w * 0.13,
        cy - h * 0.42,
        cx + w * 0.145,
        cy - h * 0.30,
      )
      ..cubicTo(
        cx + w * 0.155,
        cy - h * 0.10,
        cx + w * 0.165,
        cy + h * 0.14,
        cx + w * 0.175,
        cy + h * 0.02,
      )
      // Second tall stroke.
      ..cubicTo(
        cx + w * 0.185,
        cy - h * 0.20,
        cx + w * 0.195,
        cy - h * 0.38,
        cx + w * 0.205,
        cy - h * 0.28,
      )
      ..cubicTo(
        cx + w * 0.215,
        cy - h * 0.08,
        cx + w * 0.225,
        cy + h * 0.10,
        cx + w * 0.235,
        cy + h * 0.02,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
