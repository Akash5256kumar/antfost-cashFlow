import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_outline_button.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final VerifyAccountFlow flow;

  const VerifyAccountScreen({
    super.key,
    required this.contact,
    this.isEmail = true,
    this.flow = VerifyAccountFlow.signUp,
  });

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  static const int _otpLength = 4;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleContinue() {
    switch (widget.flow) {
      case VerifyAccountFlow.signUp:
        Navigator.of(context).pushReplacementNamed(AppRoutes.kycVerification);
        return;
      case VerifyAccountFlow.passwordRecovery:
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.signIn,
          (route) => route.settings.name == AppRoutes.getStarted,
        );
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Verify Your Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Top content ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.authBodyTop),

                // ── Subtitle ───────────────────────────────────────────────
                Text.rich(
                  TextSpan(
                    text: widget.isEmail
                        ? "Verify Your Email We've sent a 6-digit code to\n"
                        : "Verify Your Phone We've sent a 6-digit code to\n",
                    style: AppTextStyles.authScreenSubtitle,
                    children: [
                      TextSpan(
                        text: widget.contact,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.link,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.link,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // ── OTP boxes ──────────────────────────────────────────────
                _OtpRow(
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                  onChanged: _onOtpChanged,
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Validity note ──────────────────────────────────────────
                const Text(
                  'OTP valid for 5 minutes. Maximum 3 attempts allowed.',
                  style: AppTextStyles.authNote,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Bottom actions ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              0,
              AppSpacing.xxl,
              bottomInset > 0 ? bottomInset + AppSpacing.sm : AppSpacing.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppGradientButton(
                  label: 'Verify & Continue',
                  onPressed: _handleContinue,
                ),

                const SizedBox(height: AppSpacing.md),

                AppOutlineButton(
                  label: widget.isEmail ? 'Change Email' : 'Change Phone',
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: AppSpacing.xl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't Receive Code? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Resend',
                        style: AppTextStyles.authLink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── OTP row ───────────────────────────────────────────────────────────────────
class _OtpRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  const _OtpRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  static const double _boxSize = 64;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controllers.length, (i) {
        return Row(
          children: [
            _OtpBox(
              size: _boxSize,
              controller: controllers[i],
              focusNode: focusNodes[i],
              onChanged: (v) => onChanged(i, v),
            ),
            if (i < controllers.length - 1)
              const SizedBox(width: AppSpacing.lg),
          ],
        );
      }),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final double size;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.size,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _focused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: _focused ? AppColors.primary : AppColors.fieldBorder,
          width: _focused ? 1.5 : 1.2,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        expands: true,
        maxLines: null,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
