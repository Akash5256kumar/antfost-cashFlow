import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);

// ── Screen ────────────────────────────────────────────────────────────────────

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _SuccessAppBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Purple hero section
                    _HeroSection(),

                    // White body
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      child: Column(
                        children: [
                          // Order ID
                          _OrderIdCard(orderId: 'ORD-548581'),
                          const SizedBox(height: 12),
                          // Order details
                          _OrderDetailsCard(),
                          const SizedBox(height: 16),
                          // Preparing text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('🚚', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Text(
                                "We're preparing your delivery",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _textGrey,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Track Order button
                          _GradientButton(
                            label: 'Track Order',
                            onPressed: () {},
                          ),
                          const SizedBox(height: 14),
                          // Back to Home
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamedAndRemoveUntil(
                                  AppRoutes.home,
                                  (_) => false,
                                ),
                            child: const Text(
                              'Back to Home',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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

// ── App bar ───────────────────────────────────────────────────────────────────

class _SuccessAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 4),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Order Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hero section (purple bg) ──────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: Column(
        children: [
          // Badge
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Payment successful. Thank you\nfor trusting Antfast.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Estimated Waiting Time: ~30 minutes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order ID card ─────────────────────────────────────────────────────────────

class _OrderIdCard extends StatelessWidget {
  const _OrderIdCard({required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order ID',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textGrey,
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  orderId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: orderId));
            },
            icon: const Icon(Icons.copy_rounded, size: 20, color: _textGrey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ── Order details card ────────────────────────────────────────────────────────

class _OrderDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 13, color: _textGrey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Waiting for Processing',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _DashedDivider(),
          const SizedBox(height: 10),

          // Order info rows
          _SuccessInfoRow(emoji: '📍', text: 'Downtown Project'),
          const SizedBox(height: 8),
          _SuccessInfoRow(emoji: '📦', text: 'C25/30 • 50 m³'),
          const SizedBox(height: 8),
          _SuccessInfoRow(emoji: '📅', text: 'Thu 10 Feb 2026'),
          const SizedBox(height: 8),
          _SuccessInfoRow(emoji: '⏰', text: '6 AM - 12 PM (±6 hrs)'),
          const SizedBox(height: 8),
          _SuccessInfoRow(emoji: '🚚', text: '25 m³ • 3 trips'),

          const SizedBox(height: 10),
          const _DashedDivider(),
          const SizedBox(height: 10),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Tag(label: 'Technician Required'),
              _Tag(label: 'Pump (42-52)'),
            ],
          ),

          const SizedBox(height: 10),
          const _DashedDivider(),
          const SizedBox(height: 10),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Total Paid',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              Text(
                'AED 11,962.50',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessInfoRow extends StatelessWidget {
  const _SuccessInfoRow({required this.emoji, required this.text});
  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: _textDark, height: 1.3),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fieldBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: _textDark, height: 1.2),
      ),
    );
  }
}

// ── Gradient button ───────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dashed divider ────────────────────────────────────────────────────────────

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashW = 8.0;
        const dashGap = 5.0;
        final count = (constraints.maxWidth / (dashW + dashGap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(right: dashGap),
              child: const SizedBox(
                width: dashW,
                height: 1,
                child: ColoredBox(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
        );
      },
    );
  }
}
