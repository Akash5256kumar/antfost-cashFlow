import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _textDark      = Color(0xFF1A1A1A);
const Color _textGrey      = Color(0xFF9E9E9E);
const Color _fieldBorder   = Color(0xFFE8E8E8);
const Color _orderIdColor  = Color(0xFF7A6BFF);
const Color _inProgressBg  = Color(0xFFFEF3C7);
const Color _inProgressText= Color(0xFFD97706);
const Color _progressTrack = Color(0xFFE5E7EB);
const Color _progressGreen = Color(0xFF22C55E);
const Color _progressBlue  = Color(0xFF6366F1);

// ── Screen ────────────────────────────────────────────────────────────────────

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _AppBar(),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order ID card ─────────────────────────────────
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order ID',
                                style: TextStyle(
                                    fontSize: 12, color: _textGrey),
                              ),
                              _StatusBadge(),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'AF-2024-02-000001',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE9FB),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.view_in_ar_outlined,
                                  size: 22,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Product',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _textGrey,
                                      height: 1.33,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'C25/30 - Standard Mix (50 M³)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _textDark,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Live Progress ────────────────────────────────
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Live Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: const [
                              Expanded(
                                child: _ProgressTile(
                                    qty: '20m³', label: 'Delivered'),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _ProgressTile(
                                    qty: '15m³', label: 'Delivered'),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _ProgressTile(
                                    qty: '25m³', label: 'Delivered'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _GradientProgressBar(progress: 20 / 60),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Delivery Location ─────────────────────────────
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Location',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textGrey,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Marina Tower - Ground Floor',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                            icon: Icons.location_on_outlined,
                            text: 'Al Sufouh Road, Dubai Marina, Dubai',
                          ),
                          const SizedBox(height: 6),
                          _DetailRow(
                            icon: Icons.person_outline_rounded,
                            text: 'Mohammed Ali',
                          ),
                          const SizedBox(height: 6),
                          _DetailRow(
                            icon: Icons.phone_outlined,
                            text: '97150111111',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Schedule ──────────────────────────────────────
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Schedule',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textGrey,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '6 AM - 10 AM (±4 hrs)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _DetailRow(
                            icon: Icons.local_shipping_outlined,
                            text: '5 trips • 45 min gap',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Additional Services ───────────────────────────
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Additional Services',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _Tag(label: 'Technician Required'),
                              _Tag(label: 'Pump (42-52)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Payment Summary ───────────────────────────────
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _PayRow(
                              label: 'C25/30 × 50 m³',
                              value: 'AED 16,000'),
                          const SizedBox(height: 8),
                          _PayRow(
                              label: 'Pump Fee', value: 'AED 600'),
                          const SizedBox(height: 8),
                          _PayRow(
                              label: 'VAT (5%)', value: 'AED 800'),
                          const SizedBox(height: 10),
                          const Divider(
                              color: Color(0xFFE8E8E8), height: 1),
                          const SizedBox(height: 10),
                          _PayRow(
                            label: 'Total',
                            value: 'AED 17,400',
                            bold: true,
                            valueColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Buttons ───────────────────────────────────────
                    _GradientButton(
                      label: 'Order Chat',
                      icon: Icons.chat_bubble_outline_rounded,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    _OutlineButton(
                      label: 'View Invoice',
                      icon: Icons.description_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 20),
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

class _AppBar extends StatelessWidget {
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
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'AF-2026-02-000123',
                style: TextStyle(
                  fontSize: 13,
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

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _inProgressBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'in Progress',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _inProgressText,
        ),
      ),
    );
  }
}

// ── Progress tile ─────────────────────────────────────────────────────────────

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({required this.qty, required this.label});
  final String qty;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: qty.replaceAll('m³', ''),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
              children: const [
                TextSpan(
                  text: 'm³',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _textGrey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  const _GradientProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 7,
        child: Stack(
          children: [
            Container(color: _progressTrack),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_progressGreen, _progressBlue],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail row ────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: _textGrey,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Tag chip ──────────────────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fieldBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: _textDark,
          height: 1.2,
        ),
      ),
    );
  }
}

// ── Pay row ───────────────────────────────────────────────────────────────────

class _PayRow extends StatelessWidget {
  const _PayRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor = _textDark,
  });

  final String label;
  final String value;
  final bool bold;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            color: bold ? _textDark : _textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ── White card ────────────────────────────────────────────────────────────────

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: child,
    );
  }
}

// ── Gradient button ───────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Outline button ────────────────────────────────────────────────────────────

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: _textDark),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _textDark,
            letterSpacing: 0.2,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _textDark,
          side: const BorderSide(color: _fieldBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
