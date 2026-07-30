import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/home/home_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/orders/add_new_project_screen.dart';
import '../../features/orders/my_orders_screen.dart';
import '../../features/orders/new_cash_order_mix_code_screen.dart';
import '../../features/orders/new_cash_order_other_screen.dart';
import '../../features/orders/new_cash_order_quantity_screen.dart';
import '../../features/orders/new_cash_order_review_screen.dart';
import '../../features/orders/new_cash_order_schedule_screen.dart';
import '../../features/orders/new_cash_order_screen.dart';
import '../../features/orders/order_details_screen.dart';
import '../../features/orders/order_project_summary.dart';
import '../../features/payment/payment_screen.dart';
import '../../features/payment/payment_success_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/wallet/transaction_history_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import 'app_tab_navigation.dart';
import 'app_routes.dart';

class AppTabShell extends StatefulWidget {
  const AppTabShell({super.key, this.initialTab = AppTab.home});

  final AppTab initialTab;

  static AppTab tabForRoute(String? routeName) {
    switch (routeName) {
      case AppRoutes.myOrders:
        return AppTab.orders;
      case AppRoutes.wallet:
        return AppTab.wallet;
      case AppRoutes.profile:
        return AppTab.profile;
      case AppRoutes.home:
      default:
        return AppTab.home;
    }
  }

  @override
  State<AppTabShell> createState() => _AppTabShellState();
}

class _AppTabShellState extends State<AppTabShell> {
  late AppTab _currentTab;

  final Map<AppTab, GlobalKey<NavigatorState>> _navigatorKeys = {
    for (final tab in AppTab.values) tab: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  void _handleBackPress() {
    final navigator = _navigatorKeys[_currentTab]?.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return;
    }

    if (_currentTab != AppTab.home) {
      setState(() => _currentTab = AppTab.home);
      return;
    }

    SystemNavigator.pop();
  }

  void _onTabSelected(int index) {
    final selectedTab = AppTab.values[index];
    if (selectedTab == _currentTab) {
      return;
    }

    setState(() => _currentTab = selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _handleBackPress();
      },
      child: AppTabControllerScope(
        currentTab: _currentTab,
        onSelectTab: _onTabSelected,
        child: IndexedStack(
          index: _currentTab.index,
          children: AppTab.values
              .map(
                (tab) =>
                    _TabNavigator(tab: tab, navigatorKey: _navigatorKeys[tab]!),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.tab, required this.navigatorKey});

  final AppTab tab;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: tab.routeName,
      onGenerateRoute: (settings) => _buildRouteForTab(tab, settings),
    );
  }
}

Route<dynamic> _buildRouteForTab(AppTab tab, RouteSettings settings) {
  final routeName = settings.name ?? tab.routeName;

  switch (routeName) {
    case AppRoutes.home:
      return _materialRoute(
        settings: settings,
        builder: (_) => const HomeScreen(),
      );
    case AppRoutes.myOrders:
      return _materialRoute(
        settings: settings,
        builder: (_) => const MyOrdersScreen(),
      );
    case AppRoutes.wallet:
      return _materialRoute(
        settings: settings,
        builder: (_) => const WalletScreen(),
      );
    case AppRoutes.profile:
      return _materialRoute(
        settings: settings,
        builder: (_) => const ProfileScreen(),
      );
    case AppRoutes.newCashOrder:
      return _materialRoute(
        settings: settings,
        builder: (_) => const NewCashOrderScreen(),
      );
    case AppRoutes.newCashOrderMixCode:
      return _materialRoute(
        settings: settings,
        builder: (_) => const NewCashOrderMixCodeScreen(),
      );
    case AppRoutes.newCashOrderQuantity:
      return _materialRoute(
        settings: settings,
        builder: (_) => NewCashOrderQuantityScreen(
          mixCode: const MixCodeItem(
            code: 'C25/30',
            type: 'Standard Mix',
            pricePerM3: 450,
          ),
        ),
      );
    case AppRoutes.newCashOrderSchedule:
      return _materialRoute(
        settings: settings,
        builder: (_) => NewCashOrderScheduleScreen(
          mixCode: const MixCodeItem(
            code: 'C25/30',
            type: 'Standard Mix',
            pricePerM3: 450,
          ),
          quantity: 25,
        ),
      );
    case AppRoutes.newCashOrderOther:
      return _materialRoute(
        settings: settings,
        builder: (_) => NewCashOrderOtherScreen(
          mixCode: const MixCodeItem(
            code: 'C25/30',
            type: 'Standard Mix',
            pricePerM3: 450,
          ),
          quantity: 25,
        ),
      );
    case AppRoutes.newCashOrderReview:
      return _materialRoute(
        settings: settings,
        builder: (_) => NewCashOrderReviewScreen(
          mixCode: const MixCodeItem(
            code: 'C25/30',
            type: 'Standard Mix',
            pricePerM3: 450,
          ),
          quantity: 25,
          structureRef: 'Foundation',
          technicianRequired: false,
          temperatureControl: false,
          pumpRequired: false,
          cubeMould: false,
          numMoulds: 0,
        ),
      );
    case AppRoutes.payment:
      return _materialRoute(
        settings: settings,
        builder: (_) => const PaymentScreen(totalAmount: 11962.50),
      );
    case AppRoutes.paymentSuccess:
      return _materialRoute(
        settings: settings,
        builder: (_) => const PaymentSuccessScreen(),
      );
    case AppRoutes.addNewProject:
      return _materialRoute<OrderProjectSummary?>(
        settings: settings,
        builder: (_) => const AddNewProjectScreen(),
      );
    case AppRoutes.orderDetails:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderDetailsScreen(),
      );
    case AppRoutes.transactionHistory:
      return _materialRoute(
        settings: settings,
        builder: (_) => const TransactionHistoryScreen(),
      );
    case AppRoutes.notifications:
      return _materialRoute(
        settings: settings,
        builder: (_) => const NotificationsScreen(),
      );
    default:
      return _materialRoute(
        settings: settings,
        builder: (_) => switch (tab) {
          AppTab.home => const HomeScreen(),
          AppTab.orders => const MyOrdersScreen(),
          AppTab.wallet => const WalletScreen(),
          AppTab.profile => const ProfileScreen(),
        },
      );
  }
}

MaterialPageRoute<T> _materialRoute<T>({
  required RouteSettings settings,
  required WidgetBuilder builder,
}) {
  return MaterialPageRoute<T>(settings: settings, builder: builder);
}
