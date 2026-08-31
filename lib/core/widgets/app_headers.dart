import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Branded header — centered logo + optional back button + notification
/// bell. Ported from the new Figma design's `AppHeader` component
/// (`ui.tsx`). Used on top-level tab screens (Home, Orders, Projects, ...).
class AppBrandHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBrandHeader({
    super.key,
    this.showBack = false,
    this.onBack,
    this.onBellTap,
    this.showBellDot = true,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onBellTap;
  final bool showBellDot;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: showBack
                  ? _IconTapTarget(
                      onTap: onBack ?? () => Navigator.of(context).maybePop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    )
                  : null,
            ),
            const Spacer(),
            SvgPicture.asset(AppAssets.antfostLogo, height: 30),
            const Spacer(),
            SizedBox(
              width: 32,
              child: _IconTapTarget(
                onTap: onBellTap,
                child: SvgPicture.string(
                  '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
                  '<path d="M12 3C8.68629 3 6 5.68629 6 9V13.2929C6 13.8233 5.78929 14.3321 5.41421 14.7071L4.29289 15.8284C3.66299 16.4583 4.10914 17.5 5 17.5H19C19.8909 17.5 20.337 16.4583 19.7071 15.8284L18.5858 14.7071C18.2107 14.3321 18 13.8233 18 13.2929V9C18 5.68629 15.3137 3 12 3Z" stroke="#4E54F5" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
                  '<path d="M9.5 17.5C9.5 18.8807 10.6193 20 12 20C13.3807 20 14.5 18.8807 14.5 17.5" stroke="#4E54F5" stroke-width="1.8" stroke-linecap="round"/>'
                  '${showBellDot ? '<circle cx="18" cy="5" r="3.5" fill="#4E54F5" stroke="#FFFFFF" stroke-width="1.5"/>' : ''}'
                  '</svg>',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Plain header — circular back button + centered title + optional right
/// slot. Ported from the new Figma design's `TitleHeader` component.
class AppTitleHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppTitleHeader({
    super.key,
    required this.title,
    this.onBack,
    this.right,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? right;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: AppColors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  shadowColor: AppColors.textPrimary.withValues(alpha: 0.08),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.screenTitle(context),
              ),
            ),
            SizedBox(
              width: 70,
              child: Align(
                alignment: Alignment.centerRight,
                child: right == null
                    ? null
                    : DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: right!,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTapTarget extends StatelessWidget {
  const _IconTapTarget({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: IconTheme(
        data: const IconThemeData(color: AppColors.textPrimary),
        child: child,
      ),
    );
  }
}
