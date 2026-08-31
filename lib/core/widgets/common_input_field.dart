import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

/// Reusable input field for order forms.
///
/// Design spec:
///   - Height: 72 px (enforced via [SizedBox])
///   - Border radius: 16 px
///   - Label: 12 / grey (#9C9AA2) + optional pink asterisk for required
///   - Value text: 16 / medium / textPrimary
///   - Optional trailing icon (e.g. chevron-down for dropdowns)
///   - Tap to open picker → pass [onTap]; otherwise read-only display
class CommonInputField extends StatelessWidget {
  const CommonInputField({
    super.key,
    required this.label,
    required this.value,
    this.isRequired = false,
    this.trailingIcon,
    this.onTap,
    this.placeholder,
  });

  final String label;

  /// The current selected / filled value. If null or empty,
  /// [placeholder] is displayed in a lighter color.
  final String? value;

  /// Shown when [value] is null/empty.
  final String? placeholder;

  final bool isRequired;

  /// Trailing icon widget (e.g. `Icon(Icons.keyboard_arrow_down)`).
  final Widget? trailingIcon;

  /// When set the whole field becomes tappable (InkWell).
  final VoidCallback? onTap;

  // Ported from the new Figma design's `Field` component (`ui.tsx`).
  static const Color _bgColor = AppColors.white;
  static const Color _borderColor = AppColors.fieldBorder;
  static const Color _labelColor = AppColors.textSecondary;
  static const Color _valueColor = AppColors.textPrimary;
  static const Color _requiredColor = Color(0xFFFF5CA8);
  static const Color _placeholderColor = AppColors.textHint;

  bool get _hasValue => value != null && value!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: context.scaled(72),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(context.scaled(16)),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaled(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Label + value column ──────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Label row (text + optional asterisk)
                    Text.rich(
                      TextSpan(
                        text: label,
                        style: TextStyle(
                          fontSize: context.scaled(12),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          color: _labelColor,
                          height: 1.33,
                        ),
                        children: [
                          if (isRequired)
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: _requiredColor),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    // Value / placeholder
                    Text(
                      _hasValue ? value! : (placeholder ?? ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.scaled(16),
                        fontWeight: FontWeight.w500,
                        color: _hasValue ? _valueColor : _placeholderColor,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Optional trailing icon ────────────────────────────
              if (trailingIcon != null) ...[
                SizedBox(width: context.scaled(8)),
                trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return field;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.scaled(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: Colors.transparent,
        child: field,
      ),
    );
  }
}
