import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const String fontFamily = 'Poppins';

  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.white,
      ),
      fontFamily: fontFamily,
      useMaterial3: true,
    );
  }
}
