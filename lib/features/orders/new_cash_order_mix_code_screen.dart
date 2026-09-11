import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/di/injection.dart';
import '../../core/services/order_api_service.dart';
import 'new_cash_order_quantity_screen.dart';
import 'new_cash_order_draft.dart';
import 'order_step_widgets.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class MixCodeItem {
  const MixCodeItem({
    required this.code,
    required this.type,
    required this.pricePerM3,
    required this.aggregateSize,
    required this.slump,
    required this.imagePath,
    required this.mpa,
    required this.psi,
  });

  final String code;
  final String type;
  final int pricePerM3;
  final String aggregateSize;
  final String slump;
  final String imagePath;
  final String mpa;
  final String psi;
}

// ── Sample data ───────────────────────────────────────────────────────────────

const kSampleMixCodes = [
  MixCodeItem(
    code: 'C30/37',
    type: 'General Structural',
    pricePerM3: 520,
    aggregateSize: '20 mm',
    slump: 'S3',
    imagePath: AppAssets.mixThumb1,
    mpa: '37 MPa',
    psi: '5,365 PSI',
  ),
  MixCodeItem(
    code: 'C40/50',
    type: 'High Strength',
    pricePerM3: 590,
    aggregateSize: '20 mm',
    slump: 'S3',
    imagePath: AppAssets.mixThumb2,
    mpa: '50 MPa',
    psi: '7,252 PSI',
  ),
  MixCodeItem(
    code: 'C25/30',
    type: 'Foundations',
    pricePerM3: 450,
    aggregateSize: '20 mm',
    slump: 'S3',
    imagePath: AppAssets.mixThumb3,
    mpa: '30 MPa',
    psi: '4,351 PSI',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderMixCodeScreen extends StatefulWidget {
  const NewCashOrderMixCodeScreen({super.key, this.draft});

  final NewCashOrderDraft? draft;

  @override
  State<NewCashOrderMixCodeScreen> createState() =>
      _NewCashOrderMixCodeScreenState();
}

class _NewCashOrderMixCodeScreenState extends State<NewCashOrderMixCodeScreen> {
  MixCodeItem? _selected;
  late final TextEditingController _search;
  List<MixCodeItem> _mixCodes = kSampleMixCodes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController()..addListener(() => setState(() {}));
    _selected = widget.draft?.mixCode;
    _loadMixCodes();
  }

  Future<void> _loadMixCodes() async {
    final project = widget.draft?.project;
    if (project == null ||
        project.projectId.isEmpty ||
        project.locationId.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final items = await sl<OrderApiService>().mixCodes(
        projectId: project.projectId,
        locationId: project.locationId,
      );
      if (!mounted) return;
      setState(() {
        _mixCodes = items
            .where((item) => item['available'] != false)
            .map(
              (item) => MixCodeItem(
                code: item['code'] as String? ?? '',
                type: item['type'] as String? ?? '',
                pricePerM3: (item['pricePerM3'] as num?)?.round() ?? 0,
                aggregateSize: item['aggregateSize'] as String? ?? '',
                slump: item['slump'] as String? ?? '',
                imagePath: AppAssets.mixThumb1,
                mpa: item['mpa'] as String? ?? '',
                psi: item['psi'] as String? ?? '',
              ),
            )
            .where((item) => item.code.isNotEmpty)
            .toList();
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<MixCodeItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _mixCodes;
    return _mixCodes
        .where(
          (m) =>
              m.code.toLowerCase().contains(q) ||
              m.type.toLowerCase().contains(q),
        )
        .toList();
  }

  void _onContinue() {
    if (_selected == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderQuantityScreen(
          mixCode: _selected!,
          draft: widget.draft?.copyWith(mixCode: _selected!),
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
            const OrderStepperSection(currentStep: 1),
            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(24),
                    context.scaled(16),
                    context.scaled(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OrderStepHeading(
                        title: 'Select Mix Code',
                        subtitle:
                            'Choose the right concrete mix for your project.',
                      ),
                      SizedBox(height: context.scaledV(16)),

                      // Search Bar
                      Container(
                        height: context.scaled(52),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            context.scaled(14),
                          ),
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                        ),
                        child: TextField(
                          controller: _search,
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            color: kOrderTextDark,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search code or concrete grade',
                            hintStyle: TextStyle(
                              fontSize: context.scaled(13),
                              color: kOrderLabelGrey,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: context.scaled(20),
                              color: kOrderLabelGrey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: context.scaled(16),
                              vertical: context.scaledV(14),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(24)),

                      // List
                      if (_loading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No mixes available for this location.',
                            ),
                          ),
                        )
                      else
                        ...List.generate(_filtered.length, (i) {
                          final item = _filtered[i];
                          final isSelected = item.code == _selected?.code;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: context.scaledV(12),
                            ),
                            child: _MixCodeCard(
                              item: item,
                              isSelected: isSelected,
                              onTap: () => setState(() => _selected = item),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
            // Custom bottom bar with Right Chevron
            _CustomBottomBar(
              onContinue: _selected != null ? _onContinue : null,
              label: 'Continue to Quantity',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mix code card ─────────────────────────────────────────────────────────────

class _MixCodeCard extends StatelessWidget {
  const _MixCodeCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final MixCodeItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(context.scaled(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(16)),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Box
            SizedBox(
              width: context.scaled(72),
              height: context.scaled(72),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(context.scaled(12)),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFF9CA3AF),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: context.scaled(14)),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.code,
                    style: TextStyle(
                      fontSize: context.scaled(18),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: context.scaledV(2)),
                  Text(
                    item.type,
                    style: TextStyle(
                      fontSize: context.scaled(13),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: context.scaledV(8)),
                  Wrap(
                    spacing: context.scaled(6),
                    runSpacing: context.scaledV(4),
                    children: [
                      _Badge(label: item.aggregateSize, allowWrap: true),
                      if (item.slump.trim().isNotEmpty)
                        _Badge(label: item.slump),
                    ],
                  ),
                ],
              ),
            ),

            // Radio button
            Container(
              width: context.scaled(22),
              height: context.scaled(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFD1D5DB),
                  width: isSelected ? 2.0 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: context.scaled(10),
                        height: context.scaled(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.allowWrap = false});
  final String label;
  final bool allowWrap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.52,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(10),
          vertical: context.scaledV(4),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEDF7),
          borderRadius: BorderRadius.circular(context.scaled(12)),
        ),
        child: Text(
          label,
          maxLines: allowWrap ? 3 : 1,
          overflow: allowWrap ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: context.scaled(11.5),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1B4B),
          ),
        ),
      ),
    );
  }
}

// ── Custom Bottom Bar ────────────────────────────────────────────────────────

class _CustomBottomBar extends StatelessWidget {
  const _CustomBottomBar({required this.onContinue, required this.label});

  final VoidCallback? onContinue;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = bottomInset > 0
        ? bottomInset + context.scaled(12)
        : MediaQuery.paddingOf(context).bottom + context.scaled(20);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kOrderBorderSect, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.scaled(16),
          context.scaled(12),
          context.scaled(16),
          bottomPadding,
        ),
        child: PrimaryButton(arrow: true, label: label, onPressed: onContinue),
      ),
    );
  }
}
