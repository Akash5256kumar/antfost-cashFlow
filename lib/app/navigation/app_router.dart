import 'package:flutter/material.dart';

import '../../features/chat/order_chat_screen.dart';
import '../../features/invoices/domain/entities/invoice.dart';
import '../../features/invoices/invoice_details_screen.dart';
import '../../features/invoices/invoices_screen.dart';
import '../../features/invoices/qc_checkpoint_screen.dart';
import '../../features/auth/account_type_screen.dart';
import '../../features/auth/create_account_screen.dart';
import '../../features/auth/create_business_screen.dart';
import '../../features/auth/create_individual_screen.dart';
import '../../features/auth/forgot_passcode_screen.dart';
import '../../features/auth/get_started_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/auth/verify_account_screen.dart';
import '../../features/kyc/kyc_pending_screen.dart';
import '../../features/kyc/kyc_verification_screen.dart';
import '../../features/kyc/verification_status_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/orders/add_location_screen.dart';
import '../../features/orders/add_new_project_screen.dart';
import '../../features/orders/assigned_resources_screen.dart';
import '../../features/orders/confirmation_needed_screen.dart';
import '../../features/orders/loading_complete_screen.dart';
import '../../features/orders/new_cash_order_mix_code_screen.dart';
import '../../features/orders/new_cash_order_other_screen.dart';
import '../../features/orders/new_cash_order_quantity_screen.dart';
import '../../features/orders/new_cash_order_review_screen.dart';
import '../../features/orders/new_cash_order_schedule_screen.dart';
import '../../features/orders/new_cash_order_screen.dart';
import '../../features/orders/order_guide_screen.dart';
import '../../features/orders/order_details_screen.dart';
import '../../features/orders/order_saved_screen.dart';
import '../../features/orders/order_status_screen.dart';
import '../../features/orders/pouring_screen.dart';
import '../../features/orders/project_details_screen.dart';
import '../../features/orders/schedule_proposed_screen.dart';
import '../../features/orders/order_confirmed_screen.dart';
import '../../features/orders/live_tracking_screen.dart';
import '../../features/orders/order_complete_screen.dart';
import '../../features/orders/rate_delivery_screen.dart';
import '../../features/orders/agreement_summary_screen.dart';
import '../../features/orders/operations_agreement_sheet.dart';
import '../../features/orders/order_project_summary.dart';
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
import '../../features/profile/saved_sites_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/wallet/transaction_history_screen.dart';
import '../config/app_durations.dart';
import 'app_route_args.dart';
import 'app_routes.dart';
import 'app_tab_shell.dart';

class AppRouter {
  const AppRouter._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
      case AppRoutes.accountType:
        return _materialRoute(
          settings: settings,
          builder: (_) => const AccountTypeScreen(),
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
      case AppRoutes.createIndividual:
        return _materialRoute(
          settings: settings,
          builder: (_) => const CreateIndividualScreen(),
        );
      case AppRoutes.createBusiness:
        return _materialRoute(
          settings: settings,
          builder: (_) => const CreateBusinessScreen(),
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
            isBusiness: args.isBusiness,
          ),
        );
      case AppRoutes.kycVerification:
        final isBusiness = settings.arguments is bool
            ? settings.arguments as bool
            : true;
        return _materialRoute(
          settings: settings,
          builder: (_) => KycVerificationScreen(isBusiness: isBusiness),
        );
      case AppRoutes.kycPending:
        return _materialRoute(
          settings: settings,
          builder: (_) => const KycPendingScreen(),
        );
      case AppRoutes.kycVerificationStatus:
        return _materialRoute(
          settings: settings,
          builder: (_) => const VerificationStatusScreen(),
        );
      case AppRoutes.home:
        final args = settings.arguments is HomeRouteArgs
            ? settings.arguments as HomeRouteArgs
            : const HomeRouteArgs();
        return _materialRoute(
          settings: settings,
          builder: (_) => AppTabShell(
            initialTab: AppTabShell.tabForRoute(settings.name),
            verificationUnderReview: args.verificationUnderReview,
          ),
        );
      case AppRoutes.orderGuide:
        return _materialRoute(
          settings: settings,
          builder: (_) => const OrderGuideScreen(),
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
              aggregateSize: '20 mm',
              slump: 'S3',
              mpa: '30 MPa',
              psi: '4,351 PSI',
              imagePath: 'assets/images/art_concrete_cube.jpg',
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
              aggregateSize: '20 mm',
              slump: 'S3',
              mpa: '30 MPa',
              psi: '4,351 PSI',
              imagePath: 'assets/images/art_concrete_cube.jpg',
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
              aggregateSize: '20 mm',
              slump: 'S3',
              mpa: '30 MPa',
              psi: '4,351 PSI',
              imagePath: 'assets/images/art_concrete_cube.jpg',
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
              aggregateSize: '20 mm',
              slump: 'S3',
              mpa: '30 MPa',
              psi: '4,351 PSI',
              imagePath: 'assets/images/art_concrete_cube.jpg',
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
        return _materialRoute(
          settings: settings,
          builder: (_) => const TermsConditionsScreen(),
        );
      case AppRoutes.paymentSuccess:
        return _materialRoute(
          settings: settings,
          builder: (_) => const PaymentSuccessScreen(),
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
        return _materialRoute(
          settings: settings,
          builder: (_) => const AddLocationScreen(),
        );
      case AppRoutes.myOrders:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              AppTabShell(initialTab: AppTabShell.tabForRoute(settings.name)),
        );
      case AppRoutes.projects:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              AppTabShell(initialTab: AppTabShell.tabForRoute(settings.name)),
        );
      case AppRoutes.projectDetails:
        return _materialRoute(
          settings: settings,
          builder: (_) => const ProjectDetailsScreen(),
        );
      case AppRoutes.orderStatus:
        return _materialRoute(
          settings: settings,
          builder: (_) => const OrderStatusScreen(),
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
      case AppRoutes.scheduleProposed:
        return _materialRoute(
          settings: settings,
          builder: (_) => const ScheduleProposedScreen(),
        );
      case AppRoutes.orderConfirmed:
        return _materialRoute(
          settings: settings,
          builder: (_) => const OrderConfirmedScreen(),
        );
      case AppRoutes.liveTracking:
        return _materialRoute(
          settings: settings,
          builder: (_) => const LiveTrackingScreen(),
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
      case AppRoutes.agreementSummary:
        return _materialRoute(
          settings: settings,
          builder: (_) => const AgreementSummaryScreen(),
        );
      case AppRoutes.operationsAgreement:
        return _materialRoute(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: SafeArea(child: OperationsAgreementSheet())),
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
