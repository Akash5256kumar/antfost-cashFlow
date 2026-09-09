import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../payment/price_breakdown_screen.dart';
import '../payment/payment_success_screen.dart';
import 'order_saved_screen.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'order_step_widgets.dart';
import 'new_cash_order_draft.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_state.dart';

class NewCashOrderReviewScreen extends StatefulWidget {
  const NewCashOrderReviewScreen({
    super.key,
    required this.mixCode,
    required this.quantity,
    required this.structureRef,
    required this.technicianRequired,
    required this.temperatureControl,
    this.temperature,
    required this.pumpRequired,
    this.pumpName,
    required this.cubeMould,
    required this.numMoulds,
    this.siteAccessRequirements,
    this.siteAccessNotes,
    this.siteAttachmentsCount,
    this.draft,
  });

  final MixCodeItem mixCode;
  final int quantity;
  final String structureRef;
  final bool technicianRequired;
  final bool temperatureControl;
  final int? temperature;
  final bool pumpRequired;
  final String? pumpName;
  final bool cubeMould;
  final int numMoulds;
  final List<String>? siteAccessRequirements;
  final String? siteAccessNotes;
  final int? siteAttachmentsCount;
  final NewCashOrderDraft? draft;

  @override
  State<NewCashOrderReviewScreen> createState() =>
      _NewCashOrderReviewScreenState();
}

class _NewCashOrderReviewScreenState extends State<NewCashOrderReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final mixCode = draft?.mixCode ?? widget.mixCode;
    final quantity = draft?.quantity ?? widget.quantity;
    final siteAccessRequirements =
        draft?.siteAccessRequirements ??
        widget.siteAccessRequirements ??
        const [];
    final siteAttachmentsCount =
        draft?.siteAttachmentsCount ?? widget.siteAttachmentsCount ?? 0;
    final pumpRequired = draft?.pumpRequired ?? widget.pumpRequired;
    final technicianRequired =
        draft?.technicianRequired ?? widget.technicianRequired;
    final numMoulds = draft?.numMoulds ?? widget.numMoulds;
    final services = [
      if (pumpRequired) 'Pump',
      if (technicianRequired) 'Technician',
      if (numMoulds > 0) '$numMoulds cube moulds',
      if (draft?.temperatureControl ?? widget.temperatureControl)
        'Temperature control',
      if (draft?.labTesting ?? false) 'Laboratory testing',
      if (draft?.otherService ?? false) 'Other service',
    ];
    final subtotal = mixCode.pricePerM3 * quantity.toDouble();
    final pumpFee = pumpRequired ? 600.0 : 0.0;
    final total = (subtotal + pumpFee) * 1.05;
    final scheduleDate = draft?.scheduledDate;
    final scheduleLabel = scheduleDate == null
        ? 'Schedule not selected'
        : '${MaterialLocalizations.of(context).formatMediumDate(scheduleDate)} • ${draft?.timeWindow ?? 'Time window not selected'} • requested interval ${draft?.intervalMinutes ?? 15} min';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppBrandHeader(showBack: true),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.scaled(16),
                context.scaledV(16),
                context.scaled(16),
                context.scaledV(16),
              ),
              child: const OrderStepHeading(title: 'Review Order'),
            ),
            const OrderStepperSection(currentStep: 6),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Hero Image
                    Container(
                      width: double.infinity,
                      height: context.scaled(180),
                      color: Colors.white,
                      child: Image.asset(
                        AppAssets.artVillaPumpHero,
                        fit: BoxFit.contain,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(context.scaled(16)),
                      child: Column(
                        children: [
                          _ReviewRow(
                            icon: Icons.location_city_outlined,
                            title: 'Project & Location',
                            subtitle: draft?.project == null
                                ? 'Project and location not selected'
                                : '${draft!.project!.projectName} • ${draft.project!.locationLabel}',
                            onEdit: () {},
                          ),
                          SizedBox(height: context.scaledV(6)),
                          _ReviewRow(
                            icon: Icons.local_shipping_outlined,
                            title: 'Mix & Quantity',
                            subtitle: '${mixCode.code} • $quantity m³',
                            onEdit: () {},
                          ),
                          SizedBox(height: context.scaledV(6)),
                          _ReviewRow(
                            icon: Icons.calendar_today_outlined,
                            title: 'Schedule',
                            subtitle: scheduleLabel,
                            onEdit: () {},
                          ),
                          SizedBox(height: context.scaledV(6)),
                          _ReviewRow(
                            icon: Icons.person_outline,
                            title: 'Services',
                            subtitle: services.isEmpty
                                ? 'No additional services selected'
                                : services.join(' • '),
                            onEdit: () {},
                          ),
                          SizedBox(height: context.scaledV(6)),
                          _ReviewRow(
                            icon: Icons.verified_user_outlined,
                            title: 'Site Access',
                            subtitle: null,
                            onEdit: () {},
                            isExpanded: true,
                            child: Column(
                              children: [
                                _SiteAccessPill(
                                  title: 'Narrow Access',
                                  yes: siteAccessRequirements.contains(
                                    'Narrow Access',
                                  ),
                                ),
                                SizedBox(height: context.scaledV(8)),
                                _SiteAccessPill(
                                  title: 'Road Permit Required',
                                  yes: siteAccessRequirements.contains(
                                    'Road Permit Required',
                                  ),
                                ),
                                SizedBox(height: context.scaledV(8)),
                                _SiteAccessPill(
                                  title: 'Boom Reach Restriction',
                                  yes: siteAccessRequirements.contains(
                                    'Boom Reach Restriction',
                                  ),
                                ),
                                SizedBox(height: context.scaledV(8)),
                                _SiteAccessPill(
                                  title: 'Night Delivery Access',
                                  yes: siteAccessRequirements.contains(
                                    'Night Delivery Access',
                                  ),
                                ),
                                if (siteAttachmentsCount > 0) ...[
                                  SizedBox(height: context.scaledV(12)),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Attachments ($siteAttachmentsCount)',
                                      style: TextStyle(
                                        fontSize: context.scaled(12),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1F2533),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(8)),
                                  if (siteAccessRequirements.contains(
                                    'Narrow Access',
                                  )) ...[
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            context.scaled(8),
                                          ),
                                          child: Image.asset(
                                            AppAssets.mixThumb8,
                                            width: context.scaled(48),
                                            height: context.scaled(48),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: context.scaled(12)),
                                        Text(
                                          'Access photo',
                                          style: TextStyle(
                                            fontSize: context.scaled(12),
                                            color: const Color(0xFF1F2533),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: context.scaledV(8)),
                                  ],
                                  if (siteAccessRequirements.contains(
                                    'Road Permit Required',
                                  )) ...[
                                    Container(
                                      padding: EdgeInsets.all(
                                        context.scaled(10),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          context.scaled(8),
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: context.scaled(32),
                                            height: context.scaled(32),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEE2E2),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    context.scaled(6),
                                                  ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'PDF',
                                              style: TextStyle(
                                                fontSize: context.scaled(9),
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFFDC2626),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: context.scaled(10)),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Road_Permit_AF-2048.pdf',
                                                  style: TextStyle(
                                                    fontSize: context.scaled(
                                                      12,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xFF1F2533,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '1.2 MB',
                                                  style: TextStyle(
                                                    fontSize: context.scaled(
                                                      10,
                                                    ),
                                                    color: kOrderTextGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: context.scaled(14),
                            color: kOrderTextGrey,
                          ),
                          SizedBox(width: context.scaled(6)),
                          Expanded(
                            child: Text(
                              'You can review payment options after this order is saved.',
                              style: TextStyle(
                                fontSize: context.scaled(11),
                                color: kOrderTextGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(32)),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: EdgeInsets.fromLTRB(
                context.scaled(16),
                context.scaled(12),
                context.scaled(16),
                MediaQuery.paddingOf(context).bottom + context.scaled(12),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  // Default to true so it doesn't block if profile is missing
                  final isKycVerified = state is ProfileSuccess
                      ? state.profile.isKycVerified
                      : true;

                  return PrimaryButton(
                    label: 'Continue',
                    arrow: true,
                    onPressed: () {
                      if (!isKycVerified) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrderSavedScreen(
                              quantity: quantity,
                              mixCode: mixCode.code,
                              reason: OrderSavedReason.kyc,
                            ),
                          ),
                        );
                      } else {
                        PaymentSuccessScreen.currentOrderQuantity = quantity;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PriceBreakdownScreen(
                              mixCode: mixCode.code,
                              quantity: quantity,
                              totalAmount: total,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onEdit,
    this.isExpanded = false,
    this.child,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final bool isExpanded;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(14),
        vertical: context.scaledV(14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.scaled(36),
                height: context.scaled(36),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FF),
                  borderRadius: BorderRadius.circular(context.scaled(12)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: context.scaled(18),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: context.scaled(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: context.scaled(13.5),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2533),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: context.scaledV(2)),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: context.scaled(11.5),
                          color: kOrderTextGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(context.scaled(4)),
                  child: Icon(
                    Icons.edit_outlined,
                    size: context.scaled(18),
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (isExpanded && child != null) ...[
            SizedBox(height: context.scaledV(16)),
            Padding(
              padding: EdgeInsets.only(left: context.scaled(48)),
              child: child!,
            ),
          ],
        ],
      ),
    );
  }
}

class _SiteAccessPill extends StatelessWidget {
  const _SiteAccessPill({required this.title, required this.yes});
  final String title;
  final bool yes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.scaled(12.5),
            color: const Color(0xFF1F2533),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaled(10),
            vertical: context.scaledV(4),
          ),
          decoration: BoxDecoration(
            color: yes ? AppColors.primary : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(context.scaled(6)),
          ),
          child: Row(
            children: [
              if (yes) ...[
                Icon(
                  Icons.check_rounded,
                  size: context.scaled(12),
                  color: Colors.white,
                ),
                SizedBox(width: context.scaled(4)),
              ],
              Text(
                yes ? 'YES' : 'NO',
                style: TextStyle(
                  fontSize: context.scaled(10),
                  fontWeight: FontWeight.w700,
                  color: yes ? Colors.white : const Color(0xFF1F2533),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
