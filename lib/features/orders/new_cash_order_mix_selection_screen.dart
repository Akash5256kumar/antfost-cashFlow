import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_draft.dart';
import 'order_step_widgets.dart';

/// First screen of the "Mix Code" step — lets the user choose between
/// starting a fresh order or reordering a previous one. "Create New Order"
/// opens the mix-code picker directly as a bottom sheet (no intermediate
/// full-page navigation) and proceeds to Quantity once a mix is chosen.
class NewCashOrderMixSelectionScreen extends StatefulWidget {
  const NewCashOrderMixSelectionScreen({super.key, required this.draft});

  final NewCashOrderDraft draft;

  @override
  State<NewCashOrderMixSelectionScreen> createState() =>
      _NewCashOrderMixSelectionScreenState();
}

class _NewCashOrderMixSelectionScreenState
    extends State<NewCashOrderMixSelectionScreen> {
  static const int _currentStep = 1; // "Mix Code" step (0-based)

  // "Reorder Previous Order" is deliberately inert (no onTap, no selection
  // state) — "Create New Order" is the only selectable option for now.
  bool _createNewSelected = false;

  Future<void> _continue() async {
    if (!_createNewSelected) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderMixCodeScreen(draft: widget.draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBrandHeader(showBack: true),
            const OrderStepperSection(currentStep: _currentStep),
            Expanded(
              child: Container(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(24),
                    context.scaled(16),
                    context.scaled(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OrderStepHeading(
                        title: 'How would you like to order?',
                        subtitle: 'Choose how to start your concrete order.',
                      ),
                      SizedBox(height: context.scaledV(20)),

                      _OrderModeCard(
                        title: 'Create New Order',
                        subtitle: 'Start a fresh concrete order',
                        isSelected: _createNewSelected,
                        onTap: () => setState(() => _createNewSelected = true),
                      ),
                      SizedBox(height: context.scaledV(12)),

                      // Reorder is a placeholder for now — deliberately
                      // inert (no onTap, no selection state).
                      const _OrderModeCard(
                        title: 'Reorder Previous Order',
                        subtitle: 'Repeat a past concrete order',
                        isSelected: false,
                        onTap: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            OrderStepBottomBar(
              onContinue: _createNewSelected ? _continue : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order mode card ──────────────────────────────────────────────────────────

class _OrderModeCard extends StatelessWidget {
  const _OrderModeCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(context.scaled(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.scaled(16)),
            border: Border.all(
              color: isSelected ? AppColors.primary : kOrderFieldBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.scaled(16)),
            child: Row(
              children: [
                Container(
                  width: context.scaled(56),
                  height: context.scaled(56),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(context.scaled(14)),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.box,
                    width: context.scaled(26),
                    height: context.scaled(26),
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: context.scaled(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: context.scaled(16),
                          fontWeight: FontWeight.w700,
                          color: kOrderTextDark,
                        ),
                      ),
                      SizedBox(height: context.scaledV(3)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          color: kOrderTextGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: context.scaled(22),
                  color: kOrderTextGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
