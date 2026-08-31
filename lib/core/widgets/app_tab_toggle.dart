import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

const Color _trackBg = AppColors.muted;

class AppTabToggle extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AppTabToggle({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaled(4)),
      decoration: BoxDecoration(
        color: _trackBg,
        borderRadius: BorderRadius.circular(context.scaled(14)),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: context.scaled(40),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: context.scaled(6)),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(context.scaled(10)),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                // FittedBox shrinks the label to fit on one line instead of
                // wrapping — needed since some tab labels (e.g. "Individual
                // Professional") are too long to fit at the base font size
                // on narrower screens.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tabs[i],
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: context.scaled(14),
                      fontWeight: FontWeight.w600,
                      color: active ? AppColors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
