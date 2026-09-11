import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/di/injection.dart';
import '../../core/services/order_api_service.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class AgreementSummaryScreen extends StatefulWidget {
  const AgreementSummaryScreen({
    super.key,
    this.orderId = 'AF-2026-02-000189',
    this.concreteGrade = 'C35/45 SRC',
    this.slumpClass = 'S4 (160-210mm)',
    this.approvedVolume = 120,
    this.deliveryDate = 'Monday, 14 Sept 2026',
    this.timeWindow = '06:00 AM – 14:00 PM',
    this.fleetSize = '8 Ready-mix Trucks',
    this.interval = 'Every 45 Minutes',
    this.primaryPump = '36m Boom Pump',
    this.secondaryPump = 'Stationary Pump',
    this.temperatureReq = '≤ 30°C',
    this.technicianReq = 'Required',
    this.otherNotes = 'Ready-mix on demand',
    this.buttonText = 'Accept Agreement',
    this.onAccept,
  });

  final String orderId;
  final String concreteGrade;
  final String slumpClass;
  final int approvedVolume;
  final String deliveryDate;
  final String timeWindow;
  final String fleetSize;
  final String interval;
  final String primaryPump;
  final String secondaryPump;
  final String temperatureReq;
  final String technicianReq;
  final String otherNotes;
  final String buttonText;
  final VoidCallback? onAccept;

  @override
  State<AgreementSummaryScreen> createState() => _AgreementSummaryScreenState();
}

class _AgreementSummaryScreenState extends State<AgreementSummaryScreen> {
  bool _accepting = false;

  Future<void> _accept() async {
    if (widget.onAccept != null) {
      widget.onAccept!();
      return;
    }
    setState(() => _accepting = true);
    try {
      await sl<OrderApiService>().acceptOperationsAgreement(widget.orderId);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaled(16),
                vertical: context.scaledV(10),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: context.scaled(38),
                      height: context.scaled(38),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDE9FE),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: context.scaled(16),
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: context.scaled(14)),
                  Text(
                    'Agreement Summary',
                    style: TextStyle(
                      fontSize: context.scaled(20),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(18),
                  vertical: context.scaledV(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Feasibility Approved Badge ──────────────────
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

                    // ── Section 1: QUANTITY & SPEC ──────────────────
                    _SectionTitle(title: 'QUANTITY & SPEC'),
                    SizedBox(height: context.scaledV(8)),
                    _InfoCard(
                      rows: [
                        _InfoRowData(
                          label: 'Concrete Grade',
                          value: widget.concreteGrade,
                        ),
                        _InfoRowData(
                          label: 'Slump Class',
                          value: widget.slumpClass,
                        ),
                        _InfoRowData(
                          label: 'Approved Volume',
                          value: '${widget.approvedVolume} m³',
                        ),
                      ],
                    ),

                    SizedBox(height: context.scaledV(18)),

                    // ── Section 3: EQUIPMENT & PUMPS ────────────────
                    _SectionTitle(title: 'EQUIPMENT & PUMPS'),
                    SizedBox(height: context.scaledV(8)),
                    _InfoCard(
                      rows: [
                        _InfoRowData(
                          label: 'Primary Pump',
                          value: widget.primaryPump,
                        ),
                        _InfoRowData(
                          label: 'Secondary Pump',
                          value: widget.secondaryPump,
                        ),
                      ],
                    ),

                    SizedBox(height: context.scaledV(24)),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Button ────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                context.scaled(18),
                context.scaledV(12),
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
                    onPressed: _accepting ? null : _accept,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.scaled(14)),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      widget.buttonText,
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

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.scaled(12),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}

// ── Info Row Data ─────────────────────────────────────────────────────────────

class _InfoRowData {
  const _InfoRowData({required this.label, required this.value});

  final String label;
  final String value;
}

// ── Info Card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});
  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: const Color(0xFFF0F0F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaled(16),
                vertical: context.scaledV(13),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rows[i].label,
                    style: TextStyle(
                      fontSize: context.scaled(13.5),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  SizedBox(width: context.scaled(8)),
                  Flexible(
                    child: Text(
                      rows[i].value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: context.scaled(14),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < rows.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          ],
        ],
      ),
    );
  }
}
