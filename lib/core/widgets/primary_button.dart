import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

/// Full-width CTA button. Ported from the new Figma design's
/// `PrimaryButton.tsx` — solid by default, with `outline`/`ghost` variants
/// that reuse the same footprint for secondary actions, and an optional
/// trailing arrow chevron.
enum PrimaryButtonVariant { solid, outline, ghost }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = PrimaryButtonVariant.solid,
    this.arrow = false,
    this.icon,
    this.height,
    this.radius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final PrimaryButtonVariant variant;

  /// Shows a trailing chevron-right, anchored to the right edge.
  final bool arrow;

  /// Optional leading icon.
  final Widget? icon;

  /// Overrides the default [AppSpacing.buttonHeight] — some screens (e.g.
  /// onboarding's Continue, per Figma's `[&>button]:h-[54px]`) use a
  /// shorter button than the app-wide default.
  final double? height;

  /// Overrides the default [AppRadii.button].
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final enabled = !isLoading && onPressed != null;
    final borderRadius = BorderRadius.circular(
      radius ?? AppRadii.button(context),
    );

    final Color background;
    final Color foreground;
    final BoxBorder? border;
    final List<BoxShadow>? shadow;

    switch (variant) {
      case PrimaryButtonVariant.solid:
        background = enabled
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.4);
        foreground = AppColors.white;
        border = null;
        shadow = enabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null;
      case PrimaryButtonVariant.outline:
        background = AppColors.white;
        foreground = AppColors.primary;
        border = Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1,
        );
        shadow = null;
      case PrimaryButtonVariant.ghost:
        background = AppColors.primaryContainer;
        foreground = AppColors.primary;
        border = null;
        shadow = null;
    }

    final textStyle = AppTextStyles.primaryButton(
      context,
    ).copyWith(color: foreground);

    return SizedBox(
      width: double.infinity,
      height: height ?? AppSpacing.buttonHeight(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: borderRadius,
          border: border,
          boxShadow: shadow,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // `Positioned.fill` — without it, the TextButton hugs its
            // label's intrinsic size (since `padding: EdgeInsets.zero`
            // strips the default padding that would otherwise stretch it),
            // leaving only the text itself tappable instead of the whole
            // button footprint.
            Positioned.fill(
              child: TextButton(
                onPressed: isLoading ? null : onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: foreground,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  padding: EdgeInsets.zero,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: foreground,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(label, style: textStyle),
                        ],
                      ),
              ),
            ),
            if (arrow && !isLoading)
              Positioned(
                right: 24,
                child: IgnorePointer(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: foreground,
                    size: 22,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
