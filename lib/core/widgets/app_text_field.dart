import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _active ? AppColors.fieldActiveBg : AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: _active ? AppColors.primary : AppColors.fieldBorder,
          width: _active ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefixWidget != null) ...[
              // Phone-style field: label on top, prefix row below
              Text(widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: _active ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(height: 2),
              widget.prefixWidget!,
            ] else
              TextField(
                controller: widget.controller,
                focusNode: _focus,
                obscureText: widget.obscureText ? _hidden : false,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                maxLines: widget.obscureText ? 1 : widget.maxLines,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(
                    color:
                        _active ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: widget.obscureText
                      ? GestureDetector(
                          onTap: () => setState(() => _hidden = !_hidden),
                          child: Icon(
                            _hidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
