import 'package:flutter/material.dart';

import '../../app/config/app_durations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';

class AppPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const AppPageIndicator({
    required this.itemCount,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: AppDurations.indicatorAnimation,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          width: index == currentIndex
              ? AppSpacing.indicatorActiveWidth
              : AppSpacing.indicatorSize,
          height: AppSpacing.indicatorSize,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? AppColors.primary
                : AppColors.indicatorInactive,
            borderRadius: BorderRadius.circular(AppRadii.full),
          ),
        ),
      ),
    );
  }
}
