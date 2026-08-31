import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import 'app_routes.dart';

enum AppTab { home, orders, projects, wallet, profile }

extension AppTabX on AppTab {
  String get routeName => switch (this) {
    AppTab.home => AppRoutes.home,
    AppTab.orders => AppRoutes.myOrders,
    AppTab.projects => AppRoutes.projects,
    AppTab.wallet => AppRoutes.wallet,
    AppTab.profile => AppRoutes.profile,
  };
}

class AppTabControllerScope extends InheritedWidget {
  const AppTabControllerScope({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required super.child,
  });

  final AppTab currentTab;
  final ValueChanged<int> onSelectTab;

  static AppTabControllerScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppTabControllerScope>();
    assert(scope != null, 'AppTabControllerScope not found in widget tree.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppTabControllerScope oldWidget) {
    return currentTab != oldWidget.currentTab ||
        onSelectTab != oldWidget.onSelectTab;
  }
}

class AppTabBottomNavBar extends StatelessWidget {
  const AppTabBottomNavBar({super.key, required this.currentTab});

  final AppTab currentTab;

  @override
  Widget build(BuildContext context) {
    final controller = AppTabControllerScope.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset, top: 4, left: 4, right: 4),
      child: Row(
        children: List.generate(5, (index) {
          final active = index == currentTab.index;
          final color = active ? AppColors.primary : const Color(0xFF8A88A4);
          final String label = switch (index) {
            0 => 'Home',
            1 => 'Orders',
            2 => 'Projects',
            3 => 'Wallet',
            _ => 'Profile',
          };

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.onSelectTab(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 3,
                    width: 32,
                    child: active
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 6),
                  _buildTabIcon(index, color, active),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabIcon(int index, Color color, bool active) {
    final String svg = switch (index) {
      0 => active
          ? '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2.5L2.5 10.5V20.5C2.5 21.05 2.95 21.5 3.5 21.5H9.5V14.5C9.5 13.95 9.95 13.5 10.5 13.5H13.5C14.05 13.5 14.5 13.95 14.5 14.5V21.5H20.5C21.05 21.5 21.5 21.05 21.5 20.5V10.5L12 2.5Z" fill="#000000"/></svg>'
          : '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2.5L2.5 10.5V20.5C2.5 21.05 2.95 21.5 3.5 21.5H9.5V14.5C9.5 13.95 9.95 13.5 10.5 13.5H13.5C14.05 13.5 14.5 13.95 14.5 14.5V21.5H20.5C21.05 21.5 21.5 21.05 21.5 20.5V10.5L12 2.5Z" stroke="#000000" stroke-width="1.8" stroke-linejoin="round"/></svg>',
      1 => '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="4" y="4.5" width="16" height="16.5" rx="2.5" stroke="#000000" stroke-width="1.8"/><rect x="8.5" y="2" width="7" height="3" rx="1" stroke="#000000" stroke-width="1.5" fill="none"/><line x1="8" y1="10.5" x2="16" y2="10.5" stroke="#000000" stroke-width="1.8" stroke-linecap="round"/><line x1="8" y1="14.5" x2="14" y2="14.5" stroke="#000000" stroke-width="1.8" stroke-linecap="round"/></svg>',
      2 => '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><line x1="3" y1="21" x2="21" y2="21" stroke="#000000" stroke-width="1.8" stroke-linecap="round"/><rect x="5" y="4" width="8" height="17" rx="1" stroke="#000000" stroke-width="1.8"/><rect x="7" y="7" width="1.8" height="2" fill="#000000"/><rect x="9.5" y="7" width="1.8" height="2" fill="#000000"/><rect x="7" y="11" width="1.8" height="2" fill="#000000"/><rect x="9.5" y="11" width="1.8" height="2" fill="#000000"/><rect x="13" y="10" width="6" height="11" rx="1" stroke="#000000" stroke-width="1.8"/><rect x="15" y="13" width="1.8" height="2" fill="#000000"/></svg>',
      3 => '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M7 8.5V7.5C7 6.9 7.4 6.5 8 6.4L15.5 4.5C16.3 4.3 17 4.9 17 5.7V8.5" stroke="#000000" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><rect x="3.5" y="8.5" width="17" height="11" rx="2.5" stroke="#000000" stroke-width="1.6"/><path d="M16 13.5H18.5C19.3 13.5 20 14.2 20 15C20 15.8 19.3 16.5 18.5 16.5H16" stroke="#000000" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>',
      _ => '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M20 21V19C20 16.7909 18.2091 15 16 15H8C5.79086 15 4 16.7909 4 19V21" stroke="#000000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="7" r="4" stroke="#000000" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>',
    };

    return SvgPicture.string(
      svg,
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
