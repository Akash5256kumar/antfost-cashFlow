import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_review_screen.dart';
import 'order_step_widgets.dart';

// ── Site condition model (Figma's `CONDITIONS` on SiteAccess.tsx) ────────────

class _Condition {
  const _Condition(this.id, this.icon, this.label, this.desc);
  final String id;
  final IconData icon;
  final String label;
  final String desc;
}

const _conditions = [
  _Condition('narrow', Icons.alt_route_rounded, 'Narrow Access', 'Limited access for large vehicles.'),
  _Condition('permit', Icons.description_outlined, 'Road Permit Required', 'A road permit is required for delivery.'),
  _Condition('boom', Icons.local_shipping_outlined, 'Boom Reach Restriction', 'Limited pump boom reach on site.'),
  _Condition('night', Icons.nightlight_round, 'Night Delivery Access', 'Access available during night hours.'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderSiteAccessScreen extends StatefulWidget {
  const NewCashOrderSiteAccessScreen({
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

  @override
  State<NewCashOrderSiteAccessScreen> createState() =>
      _NewCashOrderSiteAccessScreenState();
}

class _NewCashOrderSiteAccessScreenState
    extends State<NewCashOrderSiteAccessScreen> {
  // Yes/No answer per Figma's CONDITIONS list (narrow/permit default Yes,
  // boom/night default No — matches Figma's sample state).
  final Map<String, bool> _answers = {
    'narrow': true,
    'permit': true,
    'boom': false,
    'night': false,
  };

  bool _confirmed = true;

  @override
  void dispose() {
    super.dispose();
  }

  void _onContinue() {
    final selectedReqs = _conditions
        .where((c) => _answers[c.id] == true)
        .map((c) => c.label)
        .toList();
    final attachmentsCount =
        (_answers['narrow'] == true ? 1 : 0) + (_answers['permit'] == true ? 1 : 0);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderReviewScreen(
          mixCode: widget.mixCode,
          quantity: widget.quantity,
          structureRef: widget.structureRef,
          technicianRequired: widget.technicianRequired,
          temperatureControl: widget.temperatureControl,
          temperature: widget.temperature,
          pumpRequired: widget.pumpRequired,
          pumpName: widget.pumpName,
          cubeMould: widget.cubeMould,
          numMoulds: widget.numMoulds,
          siteAccessRequirements: selectedReqs,
          siteAccessNotes: null,
          siteAttachmentsCount: attachmentsCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppBrandHeader(showBack: true),
            const OrderStepperSection(currentStep: 5),
            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(20),
                    context.scaled(16),
                    context.scaled(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OrderStepHeading(
                        title: 'Site Access Requirements',
                        subtitle:
                            'Answer Yes or No for every site condition.',
                      ),
                      SizedBox(height: context.scaledV(16)),

                      // ── Per-condition Yes/No cards ────────────────────
                      ...List.generate(_conditions.length, (i) {
                        final c = _conditions[i];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i == _conditions.length - 1 ? 0 : context.scaledV(12),
                          ),
                          child: _ConditionCard(
                            condition: c,
                            value: _answers[c.id],
                            onChanged: (v) => setState(() => _answers[c.id] = v),
                          ),
                        );
                      }),
                      SizedBox(height: context.scaledV(16)),

                      // ── Confirm checkbox ───────────────────────────────
                      GestureDetector(
                        onTap: () =>
                            setState(() => _confirmed = !_confirmed),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CustomCheckbox(
                              value: _confirmed,
                              onChanged: (v) =>
                                  setState(() => _confirmed = v),
                            ),
                            SizedBox(width: context.scaled(12)),
                            Expanded(
                              child: Text(
                                'I confirm the site information and access '
                                'instructions are accurate.',
                                style: TextStyle(
                                  fontSize: context.scaled(12.5),
                                  color: kOrderTextGrey,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.scaledV(16)),

                      // ── Continue / Save Draft (inside scroll) ─────────
                      PrimaryButton(
                        label: 'Continue to Review',
                        arrow: true,
                        onPressed: _confirmed ? _onContinue : null,
                      ),
                      SizedBox(height: context.scaledV(10)),
                      PrimaryButton(
                        label: 'Save Draft',
                        variant: PrimaryButtonVariant.outline,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      SizedBox(height: context.scaledV(16)),
                    ],
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

// ── Condition card (Yes/No) ───────────────────────────────────────────────────
//
// Ported from Figma's SiteAccess.tsx — each condition is its own card with
// an icon tile + label/desc row, then a Yes/No button pair, plus a
// conditional attachment preview (narrow access photo / road permit PDF).

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.condition,
    required this.value,
    required this.onChanged,
  });

  final _Condition condition;
  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final yes = value == true;
    final no = value == false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.scaled(14),
              context.scaledV(14),
              context.scaled(14),
              context.scaledV(10),
            ),
            child: Row(
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
                    condition.icon,
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
                        condition.label,
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          fontWeight: FontWeight.w600,
                          color: kOrderTextDark,
                          height: 1.25,
                        ),
                      ),
                      Text(
                        condition.desc,
                        style: TextStyle(
                          fontSize: context.scaled(11),
                          color: kOrderTextGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: kOrderTextGrey,
                  size: context.scaled(20),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.scaled(14),
              0,
              context.scaled(14),
              context.scaledV(12),
            ),
            child: Container(
              height: context.scaledV(40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.scaled(8)),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(true),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: yes ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(context.scaled(7)),
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: context.scaled(13),
                            fontWeight: FontWeight.w600,
                            color: yes ? Colors.white : const Color(0xFF1F2533),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(false),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: no ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(context.scaled(7)),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: context.scaled(13),
                            fontWeight: FontWeight.w600,
                            color: no ? Colors.white : const Color(0xFF1F2533),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (condition.id == 'narrow' && yes)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.scaled(14),
                0,
                context.scaled(14),
                context.scaledV(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Access photo',
                    style: TextStyle(
                      fontSize: context.scaled(11),
                      color: const Color(0xFF1F2533),
                    ),
                  ),
                  SizedBox(height: context.scaledV(8)),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(context.scaled(8)),
                        child: Image.asset(
                          AppAssets.mixThumb8,
                          width: context.scaled(64),
                          height: context.scaled(64),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: context.scaled(4),
                        right: context.scaled(4),
                        child: Container(
                          padding: EdgeInsets.all(context.scaled(2)),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: context.scaled(12),
                            color: const Color(0xFF1F2533),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (condition.id == 'permit' && yes)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.scaled(14),
                0,
                context.scaled(14),
                context.scaledV(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Road permit',
                    style: TextStyle(
                      fontSize: context.scaled(11),
                      color: const Color(0xFF1F2533),
                    ),
                  ),
                  SizedBox(height: context.scaledV(8)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaled(10),
                      vertical: context.scaledV(8),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(context.scaled(8)),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: context.scaled(32),
                          height: context.scaled(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(context.scaled(6)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Road_Permit_AF-2048.pdf',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: context.scaled(12),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2533),
                                ),
                              ),
                              Text(
                                '1.2 MB',
                                style: TextStyle(
                                  fontSize: context.scaled(10),
                                  color: kOrderTextGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.close_rounded,
                          size: context.scaled(16),
                          color: const Color(0xFF1F2533),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


// ── Custom Checkbox ───────────────────────────────────────────────────────────

class _CustomCheckbox extends StatelessWidget {
  const _CustomCheckbox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: context.scaled(20),
        height: context.scaled(20),
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(5)),
          border: Border.all(
            color: value ? AppColors.primary : const Color(0xFFD1D5DB),
            width: 1.5,
          ),
        ),
        child: value
            ? Icon(
                Icons.check_rounded,
                size: context.scaled(14),
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

