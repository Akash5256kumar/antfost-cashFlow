import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/home/home_screen.dart';
import '../../features/invoices/domain/entities/invoice.dart';
import '../../features/invoices/invoice_details_screen.dart';
import '../../features/invoices/invoices_screen.dart';
import '../../features/invoices/qc_checkpoint_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/chat/order_chat_screen.dart';
import '../../features/auth/forgot_passcode_screen.dart';
import '../../features/kyc/kyc_verification_screen.dart';
import '../../features/kyc/verification_status_screen.dart';
import '../../features/orders/add_location_screen.dart';
import '../../features/orders/add_new_project_screen.dart';
import '../../features/orders/assigned_resources_screen.dart';
import '../../features/orders/confirmation_needed_screen.dart';
import '../../features/orders/live_tracking_screen.dart';
import '../../features/orders/loading_complete_screen.dart';
import '../../features/orders/my_orders_screen.dart';
import '../../features/orders/order_complete_screen.dart';
import '../../features/orders/order_details_screen.dart';
import '../../features/orders/order_guide_screen.dart';
import '../../features/orders/order_project_summary.dart';
import '../../features/orders/order_saved_screen.dart';
import '../../features/orders/order_status_screen.dart';
import '../../features/orders/pouring_screen.dart';
import '../../features/orders/project_details_screen.dart';
import '../../features/orders/projects_screen.dart';
import '../../features/orders/rate_delivery_screen.dart';
import '../../features/orders/schedule_proposed_screen.dart';
import '../../features/orders/site_checkpoint_screen.dart';
import '../../features/payment/complete_payment_screen.dart';
import '../../features/payment/payment_screen.dart';
import '../../features/payment/payment_success_screen.dart';
import '../../features/payment/price_breakdown_screen.dart';
import '../../features/payment/split_wallet_payment_screen.dart';
import '../../features/payment/terms_conditions_screen.dart';
import '../../features/payment/upload_payment_proof_screen.dart';
import '../../features/profile/company_info_screen.dart';
import '../../features/profile/contact_us_screen.dart';
import '../../features/profile/documents_screen.dart';
import '../../features/profile/help_faq_screen.dart';
import '../../features/profile/personal_details_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/saved_sites_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/wallet/transaction_history_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import 'app_tab_navigation.dart';
import 'app_route_args.dart';
import 'app_routes.dart';

class AppTabShell extends StatefulWidget {
  const AppTabShell({
    super.key,
    this.initialTab = AppTab.home,
    this.verificationUnderReview = false,
  });

  final AppTab initialTab;
  final bool verificationUnderReview;

  static AppTab tabForRoute(String? routeName) {
    switch (routeName) {
      case AppRoutes.myOrders:
        return AppTab.orders;
      case AppRoutes.projects:
        return AppTab.projects;
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
      // Tapping the active tab again returns its nested navigator to the
      // tab's root screen (for example, Saved Locations → Profile).
      _navigatorKeys[selectedTab]?.currentState?.popUntil(
        (route) => route.isFirst,
      );
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
                (tab) => _TabNavigator(
                  tab: tab,
                  navigatorKey: _navigatorKeys[tab]!,
                  verificationUnderReview:
                      widget.verificationUnderReview && tab == AppTab.home,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({
    required this.tab,
    required this.navigatorKey,
    required this.verificationUnderReview,
  });

  final AppTab tab;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool verificationUnderReview;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: tab.routeName,
      onGenerateRoute: (settings) => _buildRouteForTab(
        tab,
        settings,
        verificationUnderReview: verificationUnderReview,
      ),
    );
  }
}

Route<dynamic> _buildRouteForTab(
  AppTab tab,
  RouteSettings settings, {
  required bool verificationUnderReview,
}) {
  final routeName = settings.name ?? tab.routeName;

  switch (routeName) {
    case AppRoutes.home:
      return _materialRoute(
        settings: settings,
        builder: (_) =>
            HomeScreen(verificationUnderReview: verificationUnderReview),
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
    case AppRoutes.personalDetails:
      return _materialRoute(
        settings: settings,
        builder: (_) => const PersonalDetailsScreen(),
      );
    case AppRoutes.savedSites:
      return _materialRoute(
        settings: settings,
        builder: (_) => const SavedSitesScreen(),
      );
    case AppRoutes.documents:
      return _materialRoute(
        settings: settings,
        builder: (_) => const DocumentsScreen(),
      );
    case AppRoutes.companyInfo:
      return _materialRoute(
        settings: settings,
        builder: (_) => const CompanyInfoScreen(),
      );
    case AppRoutes.settings:
      return _materialRoute(
        settings: settings,
        builder: (_) => const SettingsScreen(),
      );
    case AppRoutes.helpFaq:
      return _materialRoute(
        settings: settings,
        builder: (_) => const HelpFaqScreen(),
      );
    case AppRoutes.contactUs:
      return _materialRoute(
        settings: settings,
        builder: (_) => const ContactUsScreen(),
      );
    case AppRoutes.orderGuide:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderGuideScreen(),
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
    case AppRoutes.priceBreakdown:
      return _materialRoute(
        settings: settings,
        builder: (_) => const PriceBreakdownScreen(),
      );
    case AppRoutes.completePayment:
      return _materialRoute(
        settings: settings,
        builder: (_) => const CompletePaymentScreen(),
      );
    case AppRoutes.termsConditions:
      final nextRoute = settings.arguments as String?;
      return _materialRoute(
        settings: settings,
        builder: (_) => TermsConditionsScreen(nextRoute: nextRoute),
      );
    case AppRoutes.uploadPaymentProof:
      return _materialRoute(
        settings: settings,
        builder: (_) => const UploadPaymentProofScreen(),
      );
    case AppRoutes.splitWalletPayment:
      return _materialRoute(
        settings: settings,
        builder: (_) => const SplitWalletPaymentScreen(),
      );
    case AppRoutes.addNewProject:
      final returnResult = settings.arguments == true;
      return _materialRoute<OrderProjectSummary?>(
        settings: settings,
        builder: (_) => AddNewProjectScreen(returnResult: returnResult),
      );
    case AppRoutes.addLocation:
      final args = settings.arguments as AddLocationRouteArgs?;
      return _materialRoute(
        settings: settings,
        builder: (_) => AddLocationScreen(
          projectId: args?.projectId,
          initialLocation: args?.initialLocation,
        ),
      );
    case AppRoutes.orderSaved:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderSavedScreen(),
      );
    case AppRoutes.confirmationNeeded:
      return _materialRoute(
        settings: settings,
        builder: (_) => const ConfirmationNeededScreen(),
      );
    case AppRoutes.loadingComplete:
      return _materialRoute(
        settings: settings,
        builder: (_) => const LoadingCompleteScreen(),
      );
    case AppRoutes.siteCheckpoint:
      return _materialRoute(
        settings: settings,
        builder: (_) => const SiteCheckpointScreen(),
      );
    case AppRoutes.pouring:
      return _materialRoute(
        settings: settings,
        builder: (_) => const PouringScreen(),
      );
    case AppRoutes.assignedResources:
      return _materialRoute(
        settings: settings,
        builder: (_) => const AssignedResourcesScreen(),
      );
    case AppRoutes.projectDetails:
      return _materialRoute(
        settings: settings,
        builder: (_) => ProjectDetailsScreen(
          projectId:
              (settings.arguments as ProjectDetailsRouteArgs?)?.projectId,
        ),
      );
    case AppRoutes.orderDetails:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderDetailsScreen(),
      );
    case AppRoutes.orderChat:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderChatScreen(),
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
    case AppRoutes.invoices:
      return _materialRoute(
        settings: settings,
        builder: (_) => const InvoicesScreen(),
      );
    case AppRoutes.invoiceDetails:
      final invoice = settings.arguments is Invoice
          ? settings.arguments as Invoice
          : const Invoice(
              id: 'INV-2026-02-00001',
              orderId: 'ord-001',
              totalAmount: 22785.00,
              date: '9 Feb 2026',
              types: [InvoiceType.vat],
              status: InvoiceStatus.paid,
            );
      return _materialRoute(
        settings: settings,
        builder: (_) => InvoiceDetailsScreen(invoice: invoice),
      );
    case AppRoutes.forgotPasscode:
      return _materialRoute(
        settings: settings,
        builder: (_) => const ForgotPasscodeScreen(),
      );
    case AppRoutes.kycVerification:
      final isBusiness = settings.arguments is bool
          ? settings.arguments as bool
          : true;
      return _materialRoute(
        settings: settings,
        builder: (_) => KycVerificationScreen(isBusiness: isBusiness),
      );
    case AppRoutes.kycVerificationStatus:
      return _materialRoute(
        settings: settings,
        builder: (_) => const VerificationStatusScreen(),
      );
    case AppRoutes.liveTracking:
      return _materialRoute(
        settings: settings,
        builder: (_) => const LiveTrackingScreen(),
      );
    case AppRoutes.scheduleProposed:
      return _materialRoute(
        settings: settings,
        builder: (_) => const ScheduleProposedScreen(),
      );
    case AppRoutes.orderStatus:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderStatusScreen(),
      );
    case AppRoutes.orderConfirmed:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderDetailsScreen(),
      );
    case AppRoutes.orderComplete:
      return _materialRoute(
        settings: settings,
        builder: (_) => const OrderCompleteScreen(),
      );
    case AppRoutes.rateDelivery:
      return _materialRoute(
        settings: settings,
        builder: (_) => const RateDeliveryScreen(),
      );
    case AppRoutes.qcCheckpoint:
      final orderId = settings.arguments is String
          ? settings.arguments as String
          : 'ord-001';
      return _materialRoute(
        settings: settings,
        builder: (_) => QcCheckpointScreen(orderId: orderId),
      );
    default:
      return _materialRoute(
        settings: settings,
        builder: (_) => switch (tab) {
          AppTab.home => HomeScreen(
            verificationUnderReview: verificationUnderReview,
          ),
          AppTab.orders => const MyOrdersScreen(),
          AppTab.projects => const ProjectsScreen(),
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
