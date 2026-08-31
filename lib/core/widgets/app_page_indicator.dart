import 'package:flutter/material.dart';

import '../../app/config/app_durations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_scale.dart';
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
          // Figma: `gap-2.5` (10px) between dots — half that per side.
          margin: EdgeInsets.symmetric(horizontal: context.scaled(5)),
          width: index == currentIndex
              ? AppSpacing.indicatorActiveWidth(context)
              : AppSpacing.indicatorInactiveWidth(context),
          height: AppSpacing.indicatorSize(context),
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
