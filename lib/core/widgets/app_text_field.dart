import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import 'app_svg_icons.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixWidget;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? Function(String?)? validator;

  /// Error returned by the API for this specific field. This takes precedence
  /// over local validation until the user edits the value again.
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  /// Small leading icon shown inline with the text field itself (Figma's
  /// `Field` component). Distinct from [prefixWidget], which replaces the
  /// whole input row for the phone-number layout.
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final Widget? prefixIconWidget;

  final Widget? trailingIcon;
  final bool labelOutside;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixWidget,
    this.inputFormatters,
    this.maxLines = 1,
    this.validator,
    this.errorText,
    this.autovalidateMode,
    this.onChanged,
    this.textInputAction,
    this.leadingIcon,
    this.leadingWidget,
    this.prefixIconWidget,
    this.trailingIcon,
    this.labelOutside = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focus;
  bool _ownsFocus = false;
  bool _hidden = true;

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscureText;
    if (widget.focusNode != null) {
      _focus = widget.focusNode!;
    } else {
      _focus = FocusNode();
      _ownsFocus = true;
    }
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    if (_ownsFocus) _focus.dispose();
    super.dispose();
  }

  bool get _active => _focus.hasFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty && widget.labelOutside) ...[
          Text(
            widget.label,
            style: TextStyle(
              fontSize: context.scaled(11),
              fontWeight: FontWeight.w600,
              color: _active ? AppColors.primary : AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: context.scaledV(6)),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: _active ? AppColors.fieldActiveBg : AppColors.fieldBg,
            borderRadius: BorderRadius.circular(AppSpacing.md(context)),
            border: Border.all(
              color: _active ? AppColors.primary : AppColors.fieldBorder,
              width: _active ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg(context),
              vertical: AppSpacing.xs(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.prefixWidget != null) ...[
                  if (!widget.labelOutside && widget.label.isNotEmpty) ...[
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        color: _active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: context.scaledV(2)),
                  ],
                  widget.prefixWidget!,
                ] else
                  TextFormField(
                    controller: widget.controller,
                    focusNode: _focus,
                    obscureText: widget.obscureText ? _hidden : false,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    validator: widget.validator,
                    autovalidateMode: widget.autovalidateMode,
                    onChanged: widget.onChanged,
                    textInputAction: widget.textInputAction,
                    maxLines: widget.obscureText ? 1 : widget.maxLines,
                    style: TextStyle(
                      fontSize: context.scaled(15),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.labelOutside ? null : widget.label,
                      errorText: widget.errorText,
                      labelStyle: TextStyle(
                        color: _active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: context.scaled(14),
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: context.scaled(15),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: context.scaled(10),
                      ),
                      prefixIcon: widget.prefixIconWidget != null
                          ? widget.prefixIconWidget
                          : (widget.leadingWidget == null
                              ? (widget.leadingIcon == null
                                    ? null
                                    : Icon(
                                        widget.leadingIcon,
                                        size: context.scaled(20),
                                        color: _active
                                            ? AppColors.primary
                                            : AppColors.iconMuted,
                                      ))
                              : UnconstrainedBox(
                                  child: SizedBox(
                                    width: context.scaled(28),
                                    height: context.scaled(24),
                                    child: Center(child: widget.leadingWidget),
                                  ),
                                )),
                      prefixIconConstraints: widget.prefixIconWidget != null
                          ? const BoxConstraints()
                          : BoxConstraints(
                              minWidth: context.scaled(32),
                            ),
                      suffixIcon: widget.obscureText
                          ? GestureDetector(
                              onTap: () => setState(() => _hidden = !_hidden),
                              child: UnconstrainedBox(
                                child: _hidden
                                    ? const AppSvgEyeIcon()
                                    : const AppSvgEyeOffIcon(),
                              ),
                            )
                          : widget.trailingIcon,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
