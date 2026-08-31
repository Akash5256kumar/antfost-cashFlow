import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';

/// Ported from the new Figma design's `screens/AccountType.tsx` — lets a
/// new user choose Individual vs Business before filling in the
/// corresponding sign-up form.
class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

enum _AccountKind { business, individual }

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  _AccountKind _selected = _AccountKind.business;

  void _continue() {
    Navigator.of(context).pushNamed(
      _selected == _AccountKind.business
          ? AppRoutes.createBusiness
          : AppRoutes.createIndividual,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTitleHeader(
        title: 'Create Account',
        right: Text('Step 1 of 3', style: AppTextStyles.cardSubtitle(context)),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg(context),
            0,
            AppSpacing.lg(context),
            AppSpacing.xxl(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.scaledV(12)),
              Text(
                'How will you use ANTFAST?',
                style: AppTextStyles.authScreenTitle(context),
              ),
              SizedBox(height: context.scaledV(4)),
              Text(
                'Choose one account type to continue.',
                style: AppTextStyles.cardSubtitle(context),
              ),
              SizedBox(height: context.scaledV(24)),
              _OptionCard(
                iconWidget: const _BusinessCardIcon(),
                title: 'Business',
                description: 'For companies with industrial licences.',
                selected: _selected == _AccountKind.business,
                onTap: () => setState(() => _selected = _AccountKind.business),
              ),
              SizedBox(height: context.scaledV(16)),
              _OptionCard(
                iconWidget: const _IndividualCardIcon(),
                title: 'Individual',
                description: 'For personal use.',
                selected: _selected == _AccountKind.individual,
                onTap: () =>
                    setState(() => _selected = _AccountKind.individual),
              ),
              const Spacer(),
              SizedBox(height: context.scaledV(24)),
              PrimaryButton(
                onPressed: _continue,
                arrow: true,
                label: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BusinessCardIcon extends StatelessWidget {
  const _BusinessCardIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<path d="M5 20V6C5 4.89543 5.89543 4 7 4H12C13.1046 4 14 4.89543 14 6V20M5 20H14M5 20H3M14 20H19C19.5523 20 20 19.5523 20 19V10.5C20 9.94772 19.5523 9.5 19 9.5H14" stroke="#4E54F5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M8 14H11V20H8V14Z" stroke="#4E54F5" stroke-width="1.8" stroke-linejoin="round"/>'
      '<path d="M16 13.5H17.5" stroke="#4E54F5" stroke-width="2" stroke-linecap="round"/>'
      '</svg>',
      width: 24,
      height: 24,
    );
  }
}

class _IndividualCardIcon extends StatelessWidget {
  const _IndividualCardIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<circle cx="12" cy="8" r="3.5" stroke="#4E54F5" stroke-width="2"/>'
      '<path d="M6 19C6 16.2386 8.68629 14 12 14C15.3137 14 18 16.2386 18 19" stroke="#4E54F5" stroke-width="2" stroke-linecap="round"/>'
      '</svg>',
      width: 24,
      height: 24,
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.iconWidget,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final Widget iconWidget;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg(context),
          vertical: context.scaledV(18),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 1.5 : 1.0,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2FE),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: iconWidget,
            ),
            SizedBox(width: AppSpacing.lg(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle(context)),
                  const SizedBox(height: 3),
                  Text(description, style: AppTextStyles.cardSubtitle(context)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFFD3D1E4),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
