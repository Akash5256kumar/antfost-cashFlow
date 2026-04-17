import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

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

  // ── Design tokens ──────────────────────────────────────────────────
  static const double _height = 72;
  static const double _radius = 16;
  static const double _labelSize = 12;
  static const double _valueSize = 16;

  // Exact Figma colours
  static const Color _bgColor       = Color(0xFFF7F7F7);
  static const Color _borderColor   = Color(0xFFE8E8E8);
  static const Color _labelColor    = Color(0xFF9E9E9E);
  static const Color _valueColor    = Color(0xFF1A1A1A);
  static const Color _requiredColor = Color(0xFFFF5CA8);
  static const Color _placeholderColor = Color(0xFFBBBBBB);

  bool get _hasValue => value != null && value!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: _height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                        style: const TextStyle(
                          fontSize: _labelSize,
                          fontWeight: FontWeight.w400,
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
                    const SizedBox(height: 4),
                    // Value / placeholder
                    Text(
                      _hasValue ? value! : (placeholder ?? ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _valueSize,
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
                const SizedBox(width: 8),
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
      borderRadius: BorderRadius.circular(_radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: Colors.transparent,
        child: field,
      ),
    );
  }
}
