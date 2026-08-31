import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Status pill, ported from the new Figma design's `Badge` component
/// (`ui.tsx`). Each tone carries a background tint, a foreground text
/// color, and an optional leading icon.
enum AppStatusTone {
  scheduled,
  onWay,
  confirm,
  completed,
  active,
  planning,
  review,
}

class _ToneStyle {
  const _ToneStyle({required this.bg, required this.fg, this.icon});
  final Color bg;
  final Color fg;
  final IconData? icon;
}

const Map<AppStatusTone, _ToneStyle> _tones = {
  AppStatusTone.scheduled: _ToneStyle(
    bg: AppColors.infoContainer,
    fg: AppColors.infoText,
    icon: Icons.calendar_today_rounded,
  ),
  AppStatusTone.onWay: _ToneStyle(
    bg: AppColors.primaryContainer,
    fg: AppColors.primary,
    icon: Icons.local_shipping_rounded,
  ),
  AppStatusTone.confirm: _ToneStyle(
    bg: AppColors.warningContainer,
    fg: AppColors.warning,
    icon: Icons.access_time_rounded,
  ),
  AppStatusTone.completed: _ToneStyle(
    bg: AppColors.successContainer,
    fg: AppColors.success,
    icon: Icons.check_rounded,
  ),
  AppStatusTone.active: _ToneStyle(
    bg: AppColors.successContainer,
    fg: AppColors.success,
    icon: Icons.check_circle_outline_rounded,
  ),
  AppStatusTone.planning: _ToneStyle(
    bg: AppColors.successContainer,
    fg: AppColors.success,
  ),
  AppStatusTone.review: _ToneStyle(
    bg: AppColors.muted,
    fg: AppColors.textSecondary,
    icon: Icons.access_time_rounded,
  ),
};

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    this.tone = AppStatusTone.scheduled,
    this.showIcon = true,
  });

  final String label;
  final AppStatusTone tone;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final style = _tones[tone]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && style.icon != null) ...[
            Icon(style.icon, size: 13, color: style.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.badgeLabel(context).copyWith(color: style.fg),
          ),
        ],
      ),
    );
  }
}
