import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

// ── Screen 1: Operations Approved Summary (Left Screen in flutter_03.png) ──────

class OperationsAgreementSheet extends StatelessWidget {
  const OperationsAgreementSheet({
    super.key,
    this.approvedQuantity = 120,
    this.deliveryDate = '15 Jul 2026',
    this.deliveryShift = 'Morning (06:00–12:00)',
    this.deliveryInterval = 'Every 60 min',
    this.pumpRequired = true,
    this.temperatureReq = '≤ 30°C',
    this.technicianRequired = true,
    this.otherNotes = 'Ready-mix on demand',
    this.onContinue,
  });

  final int approvedQuantity;
  final String deliveryDate;
  final String deliveryShift;
  final String deliveryInterval;
  final bool pumpRequired;
  final String temperatureReq;
  final bool technicianRequired;
  final String otherNotes;
  final VoidCallback? onContinue;

  /// Helper to display this as a bottom sheet modal
  static Future<void> show(
    BuildContext context, {
    int approvedQuantity = 120,
    String deliveryDate = '15 Jul 2026',
    String deliveryShift = 'Morning (06:00–12:00)',
    String deliveryInterval = 'Every 60 min',
    bool pumpRequired = true,
    String temperatureReq = '≤ 30°C',
    bool technicianRequired = true,
    String otherNotes = 'Ready-mix on demand',
    VoidCallback? onContinue,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OperationsAgreementSheet(
        approvedQuantity: approvedQuantity,
        deliveryDate: deliveryDate,
        deliveryShift: deliveryShift,
        deliveryInterval: deliveryInterval,
        pumpRequired: pumpRequired,
        temperatureReq: temperatureReq,
        technicianRequired: technicianRequired,
        otherNotes: otherNotes,
        onContinue: onContinue ?? () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.scaled(24)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top Header with Drag Handle ─────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.scaled(20),
                context.scaledV(12),
                context.scaled(20),
                context.scaledV(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: context.scaled(36),
                      height: context.scaledV(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(14)),
                  Text(
                    'Agreement Summary',
                    style: TextStyle(
                      fontSize: context.scaled(20),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: context.scaledV(3)),
                  Text(
                    'Large Order · Operations Approved',
                    style: TextStyle(
                      fontSize: context.scaled(13),
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ─────────────────────────────────────────────
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // ── Scrollable Body ─────────────────────────────────────
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(18),
                  vertical: context.scaledV(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟢 Feasibility Approved Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(12),
                        vertical: context.scaledV(6),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(context.scaled(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: context.scaled(7),
                            height: context.scaled(7),
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: context.scaled(7)),
                          Text(
                            'Feasibility Approved',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.scaledV(18)),

                    // 1. QUANTITY DETAILS
                    _SectionHeader(title: 'QUANTITY DETAILS'),
                    SizedBox(height: context.scaledV(8)),
                    _SheetCard(
                      children: [
                        _SheetRow(
                          label: 'Approved Quantity',
                          value: '$approvedQuantity m³',
                          valueStyle: TextStyle(
                            fontSize: context.scaled(15),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),



                    // 3. SERVICE REQUIREMENTS
                    _SectionHeader(title: 'SERVICE REQUIREMENTS'),
                    SizedBox(height: context.scaledV(8)),
                    _SheetCard(
                      children: [
                        _SheetRow(
                          label: 'Pump Requirement',
                          value: pumpRequired ? 'Required' : 'Not Required',
                          valueColor: pumpRequired
                              ? AppColors.primary
                              : const Color(0xFF111827),
                        ),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        _SheetRow(
                          label: 'Temperature Req.',
                          value: temperatureReq,
                        ),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        _SheetRow(
                          label: 'Technician Req.',
                          value: technicianRequired ? 'Required' : 'Not Required',
                          valueColor: technicianRequired
                              ? AppColors.primary
                              : const Color(0xFF111827),
                        ),
                      ],
                    ),

                    SizedBox(height: context.scaledV(18)),

                    // 4. OTHER AGREED REQUIREMENTS
                    _SectionHeader(title: 'OTHER AGREED REQUIREMENTS'),
                    SizedBox(height: context.scaledV(8)),
                    _SheetCard(
                      children: [
                        _SheetRow(
                          label: 'Other Notes',
                          value: otherNotes,
                        ),
                      ],
                    ),

                    SizedBox(height: context.scaledV(16)),

                    // Operations banner note
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(14),
                        vertical: context.scaledV(12),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(context.scaled(12)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Reviewed and approved by Operations for orders > 100 m³',
                        style: TextStyle(
                          fontSize: context.scaled(12.5),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: context.scaledV(12)),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Button ────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                context.scaled(18),
                context.scaledV(10),
                context.scaled(18),
                context.scaledV(16),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: context.scaled(52),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryGradientStart,
                        AppColors.primaryGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(context.scaled(14)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (onContinue != null) {
                        onContinue!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.scaled(14)),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Continue to Order',
                      style: TextStyle(
                        fontSize: context.scaled(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.scaled(11.5),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}

class _SheetCard extends StatelessWidget {
  const _SheetCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(14)),
        border: Border.all(color: const Color(0xFFF0F0F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueStyle,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(16),
        vertical: context.scaledV(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context.scaled(13.5),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(width: context.scaled(8)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ??
                  TextStyle(
                    fontSize: context.scaled(14),
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF111827),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
