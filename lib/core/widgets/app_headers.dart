import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_notification_bell.dart';

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
    this.showChat = false,
    this.onChatTap,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onBellTap;
  final bool showBellDot;
  final bool showChat;
  final VoidCallback? onChatTap;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: showBack
                  ? _IconTapTarget(
                      onTap: onBack ?? () => Navigator.of(context).maybePop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    )
                  : const SizedBox(width: 32),
            ),
            SvgPicture.asset(AppAssets.antfostLogo, height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showChat) ...[
                    _IconTapTarget(
                      onTap: onChatTap,
                      child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textPrimary, size: 22),
                    ),
                    const SizedBox(width: 16),
                  ],
                  AppNotificationBell(
                    onTap: onBellTap,
                    showBellDot: showBellDot,
                    color: const Color(0xFF4E54F5),
                  ),
                ],
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
