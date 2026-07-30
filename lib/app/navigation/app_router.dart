import 'package:flutter/material.dart';

import '../../features/invoices/domain/entities/invoice.dart';
import '../../features/invoices/invoice_details_screen.dart';
import '../../features/invoices/invoices_screen.dart';
import '../../features/invoices/qc_checkpoint_screen.dart';
import '../../features/auth/create_account_screen.dart';
import '../../features/auth/forgot_passcode_screen.dart';
import '../../features/auth/get_started_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/auth/verify_account_screen.dart';
import '../../features/kyc/kyc_pending_screen.dart';
import '../../features/kyc/kyc_verification_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/orders/add_new_project_screen.dart';
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
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/wallet/transaction_history_screen.dart';
import '../config/app_durations.dart';
import 'app_route_args.dart';
import 'app_routes.dart';
import 'app_tab_shell.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _materialRoute(
          settings: settings,
          builder: (_) => const SplashPage(),
        );
      case AppRoutes.onboarding:
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: AppDurations.splashTransition,
        );
      case AppRoutes.getStarted:
        return _materialRoute(
          settings: settings,
          builder: (_) => const GetStartedScreen(),
        );
      case AppRoutes.signIn:
        return _materialRoute(
          settings: settings,
          builder: (_) => const SignInScreen(),
        );
      case AppRoutes.createAccount:
        final args = settings.arguments is CreateAccountRouteArgs
            ? settings.arguments as CreateAccountRouteArgs
            : const CreateAccountRouteArgs(
                entryPoint: CreateAccountEntryPoint.getStarted,
              );
        return _materialRoute(
          settings: settings,
          builder: (_) => CreateAccountScreen(entryPoint: args.entryPoint),
        );
      case AppRoutes.forgotPasscode:
        return _materialRoute(
          settings: settings,
          builder: (_) => const ForgotPasscodeScreen(),
        );
      case AppRoutes.verifyAccount:
        final args = settings.arguments is VerifyAccountRouteArgs
            ? settings.arguments as VerifyAccountRouteArgs
            : const VerifyAccountRouteArgs(
                contact: 'Sample.email@.com',
                isEmail: true,
                flow: VerifyAccountFlow.signUp,
              );
        return _materialRoute(
          settings: settings,
          builder: (_) => VerifyAccountScreen(
            contact: args.contact,
            isEmail: args.isEmail,
            flow: args.flow,
          ),
        );
      case AppRoutes.kycVerification:
        return _materialRoute(
          settings: settings,
          builder: (_) => const KycVerificationScreen(),
        );
      case AppRoutes.kycPending:
        return _materialRoute(
          settings: settings,
          builder: (_) => const KycPendingScreen(),
        );
      case AppRoutes.home:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              AppTabShell(initialTab: AppTabShell.tabForRoute(settings.name)),
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
      case AppRoutes.myOrders:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              AppTabShell(initialTab: AppTabShell.tabForRoute(settings.name)),
        );
      case AppRoutes.orderDetails:
        return _materialRoute(
          settings: settings,
          builder: (_) => const OrderDetailsScreen(),
        );
      case AppRoutes.wallet:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              AppTabShell(initialTab: AppTabShell.tabForRoute(settings.name)),
        );
      case AppRoutes.profile:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              AppTabShell(initialTab: AppTabShell.tabForRoute(settings.name)),
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
        // Use the domain Invoice entity instead of the former local InvoiceItem.
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
      case AppRoutes.qcCheckpoint:
        final invoiceId = settings.arguments is String
            ? settings.arguments as String
            : 'INV-2026-02-00001';
        return _materialRoute(
          settings: settings,
          builder: (_) => QcCheckpointScreen(invoiceId: invoiceId),
        );
      default:
        return _materialRoute(
          settings: settings,
          builder: (_) => const SplashPage(),
        );
    }
  }

  static MaterialPageRoute<T> _materialRoute<T>({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return MaterialPageRoute<T>(settings: settings, builder: builder);
  }
}
