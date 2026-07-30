import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_routes.dart';

enum AppTab { home, orders, wallet, profile }

extension AppTabX on AppTab {
  String get routeName => switch (this) {
    AppTab.home => AppRoutes.home,
    AppTab.orders => AppRoutes.myOrders,
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

  static const _items = [
    _NavItem(
      activeIcon: Icons.home_rounded,
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItem(
      activeIcon: Icons.receipt_long_rounded,
      icon: Icons.receipt_long_outlined,
      label: 'Orders',
    ),
    _NavItem(
      activeIcon: Icons.account_balance_wallet_rounded,
      icon: Icons.account_balance_wallet_outlined,
      label: 'Wallet',
    ),
    _NavItem(
      activeIcon: Icons.person_rounded,
      icon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = AppTabControllerScope.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.fieldBorder)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final active = index == currentTab.index;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.onSelectTab(index),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      active ? item.activeIcon : item.icon,
                      size: 24,
                      color: active ? AppColors.primary : AppColors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: active
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.activeIcon,
    required this.icon,
    required this.label,
  });

  final IconData activeIcon;
  final IconData icon;
  final String label;
}
