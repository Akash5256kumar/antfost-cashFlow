abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/auth/sign-in';
  static const String accountType = '/auth/account-type';
  static const String createIndividual = '/auth/create-individual';
  static const String createBusiness = '/auth/create-business';
  static const String forgotPasscode = '/auth/forgot-passcode';
  static const String verifyAccount = '/auth/verify-account';
  static const String kycVerification = '/kyc/verification';
  static const String kycVerificationStatus = '/kyc/verification-status';
  static const String orderGuide = '/orders/guide';
  static const String newCashOrder = '/orders/new-cash-order';
  static const String newCashOrderMixCode = '/orders/new-cash-order/mix-code';
  static const String newCashOrderQuantity = '/orders/new-cash-order/quantity';
  static const String newCashOrderSchedule = '/orders/new-cash-order/schedule';
  static const String newCashOrderOther = '/orders/new-cash-order/other';
  static const String newCashOrderReview = '/orders/new-cash-order/review';
  // Note: NewCashOrderMixSelectionScreen and NewCashOrderSiteAccessScreen
  // stay as direct Navigator.push calls (not named routes) until Phase 7
  // (new-order wizard redesign), when their state threading moves onto
  // NewCashOrderBloc and a route with real arguments becomes possible.
  static const String payment = '/payment';
  static const String completePayment = '/payment/complete';
  static const String priceBreakdown = '/payment/price-breakdown';
  static const String termsConditions = '/payment/terms';
  static const String paymentSuccess = '/payment/success';
  static const String uploadPaymentProof = '/payment/upload-proof';
  static const String splitWalletPayment = '/payment/split-wallet';
  static const String addNewProject = '/orders/add-new-project';
  static const String addLocation = '/orders/add-location';
  static const String myOrders = '/orders';
  static const String projects = '/projects';
  static const String projectDetails = '/projects/details';
  static const String orderStatus = '/orders/status';
  static const String orderSaved = '/orders/saved';
  static const String confirmationNeeded = '/orders/confirmation-needed';
  static const String scheduleProposed = '/orders/schedule-proposed';
  static const String orderConfirmed = '/orders/confirmed';
  static const String liveTracking = '/orders/live-tracking';
  static const String loadingComplete = '/orders/loading-complete';
  static const String siteCheckpoint = '/orders/site-checkpoint';
  static const String pouring = '/orders/pouring';
  static const String assignedResources = '/orders/assigned-resources';
  static const String orderComplete = '/orders/complete';
  static const String rateDelivery = '/orders/rate-delivery';
  static const String agreementSummary = '/orders/agreement-summary';
  static const String operationsAgreement = '/orders/operations-agreement';
  static const String orderDetails = '/orders/details';
  static const String orderChat = '/orders/chat';
  static const String wallet = '/wallet';
  static const String transactionHistory = '/wallet/transactions';
  static const String invoices = '/invoices';
  static const String invoiceDetails = '/invoices/details';
  static const String qcCheckpoint = '/invoices/qc';
  static const String profile = '/profile';
  static const String personalDetails = '/profile/personal-details';
  static const String savedSites = '/profile/saved-sites';
  static const String documents = '/profile/documents';
  static const String companyInfo = '/profile/company-info';
  static const String settings = '/profile/settings';
  static const String helpFaq = '/profile/help-faq';
  static const String contactUs = '/profile/contact-us';
  static const String notifications = '/notifications';
  static const String home = '/home';
}
