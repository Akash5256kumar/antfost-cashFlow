import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

/// Compact country code picker that constrains its tap area strictly to the
/// flag, dial code, and dropdown arrow, preventing accidental triggers when
/// the user taps into the phone number input field.
class AppCountryCodePicker extends StatelessWidget {
  const AppCountryCodePicker({
    super.key,
    required this.onChanged,
    this.initialSelection = 'AE',
    this.favorite = const ['+971', '+966', '+1', '+91'],
  });

  final ValueChanged<CountryCode> onChanged;
  final String initialSelection;
  final List<String> favorite;

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      onChanged: onChanged,
      initialSelection: initialSelection,
      favorite: favorite,
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      padding: EdgeInsets.zero,
      builder: (countryCode) {
        return Padding(
          padding: EdgeInsets.only(right: context.scaled(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (countryCode?.flagUri != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.scaled(2)),
                  child: Image.asset(
                    countryCode!.flagUri!,
                    package: 'country_code_picker',
                    width: context.scaled(24),
                    height: context.scaled(16),
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(width: context.scaled(6)),
              Text(
                countryCode?.dialCode ?? '+971',
                style: TextStyle(
                  fontSize: context.scaled(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: context.scaled(2)),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: context.scaled(18),
                color: AppColors.textSecondary,
              ),
              SizedBox(width: context.scaled(8)),
              Container(
                height: context.scaledV(20),
                width: 1,
                color: const Color(0xFFE2E8F0),
              ),
            ],
          ),
        );
      },
    );
  }
}
