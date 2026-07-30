import 'package:get_it/get_it.dart';

import '../../core/network/network_info.dart';

// ── Auth ──────────────────────────────────────────────────────────────────────
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_passcode_use_case.dart';
import '../../features/auth/domain/usecases/get_cached_user_use_case.dart';
import '../../features/auth/domain/usecases/reset_passcode_use_case.dart';
import '../../features/auth/domain/usecases/sign_in_use_case.dart';
import '../../features/auth/domain/usecases/sign_out_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/domain/usecases/verify_otp_use_case.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// ── Home ──────────────────────────────────────────────────────────────────────
import '../../features/home/data/datasources/home_local_data_source.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data_use_case.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

// ── Orders ────────────────────────────────────────────────────────────────────
import '../../features/orders/data/datasources/orders_local_data_source.dart';
import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/add_project_use_case.dart';
import '../../features/orders/domain/usecases/create_cash_order_use_case.dart';
import '../../features/orders/domain/usecases/get_mix_codes_use_case.dart';
import '../../features/orders/domain/usecases/get_order_details_use_case.dart';
import '../../features/orders/domain/usecases/get_orders_use_case.dart';
import '../../features/orders/domain/usecases/get_projects_use_case.dart';
import '../../features/orders/presentation/bloc/new_cash_order_bloc.dart';
import '../../features/orders/presentation/bloc/orders_bloc.dart';

// ── Invoices ──────────────────────────────────────────────────────────────────
import '../../features/invoices/data/datasources/invoices_local_data_source.dart';
import '../../features/invoices/data/datasources/invoices_remote_data_source.dart';
import '../../features/invoices/data/repositories/invoices_repository_impl.dart';
import '../../features/invoices/domain/repositories/invoices_repository.dart';
import '../../features/invoices/domain/usecases/download_invoice_use_case.dart';
import '../../features/invoices/domain/usecases/get_invoice_detail_use_case.dart';
import '../../features/invoices/domain/usecases/get_invoices_use_case.dart';
import '../../features/invoices/presentation/bloc/invoice_detail_bloc.dart';
import '../../features/invoices/presentation/bloc/invoices_bloc.dart';

// ── Wallet ────────────────────────────────────────────────────────────────────
import '../../features/wallet/data/datasources/wallet_local_data_source.dart';
import '../../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/wallet/domain/usecases/add_funds_use_case.dart';
import '../../features/wallet/domain/usecases/get_transactions_use_case.dart';
import '../../features/wallet/domain/usecases/get_wallet_balance_use_case.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';

// ── Payment ───────────────────────────────────────────────────────────────────
import '../../features/payment/data/datasources/payment_local_data_source.dart';
import '../../features/payment/data/datasources/payment_remote_data_source.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/initiate_payment_use_case.dart';
import '../../features/payment/domain/usecases/verify_payment_use_case.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';

// ── Profile ───────────────────────────────────────────────────────────────────
import '../../features/profile/data/datasources/profile_local_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_use_case.dart';
import '../../features/profile/domain/usecases/update_profile_use_case.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

// ── Notifications ─────────────────────────────────────────────────────────────
import '../../features/notifications/data/datasources/notifications_local_data_source.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications_use_case.dart';
import '../../features/notifications/domain/usecases/mark_all_read_use_case.dart';
import '../../features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';

// ── KYC ───────────────────────────────────────────────────────────────────────
import '../../features/kyc/data/datasources/kyc_local_data_source.dart';
import '../../features/kyc/data/datasources/kyc_remote_data_source.dart';
import '../../features/kyc/data/repositories/kyc_repository_impl.dart';
import '../../features/kyc/domain/repositories/kyc_repository.dart';
import '../../features/kyc/domain/usecases/get_kyc_status_use_case.dart';
import '../../features/kyc/domain/usecases/submit_kyc_use_case.dart';
import '../../features/kyc/presentation/bloc/kyc_bloc.dart';

// ── Onboarding ────────────────────────────────────────────────────────────────
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_use_case.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_pages_use_case.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';

// ── Splash ────────────────────────────────────────────────────────────────────
import '../../features/splash/data/datasources/splash_local_data_source.dart';
import '../../features/splash/data/repositories/splash_repository_impl.dart';
import '../../features/splash/domain/repositories/splash_repository.dart';
import '../../features/splash/domain/usecases/get_app_launch_state_use_case.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(() => const NetworkInfoImpl());

  // ── Auth ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => MockAuthRemoteDataSource(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => MockAuthLocalDataSource(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasscodeUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasscodeUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      verifyOtpUseCase: sl(),
      forgotPasscodeUseCase: sl(),
      resetPasscodeUseCase: sl(),
      signOutUseCase: sl(),
      getCachedUserUseCase: sl(),
    ),
  );

  // ── Home ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => MockHomeRemoteDataSource(),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => MockHomeLocalDataSource(),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetHomeDataUseCase(sl()));
  sl.registerFactory(() => HomeBloc(getHomeDataUseCase: sl()));

  // ── Orders ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => MockOrdersRemoteDataSource(),
  );
  sl.registerLazySingleton<OrdersLocalDataSource>(
    () => MockOrdersLocalDataSource(),
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetMixCodesUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => AddProjectUseCase(sl()));
  sl.registerLazySingleton(() => CreateCashOrderUseCase(sl()));
  sl.registerFactory(() => OrdersBloc(getOrdersUseCase: sl()));
  sl.registerFactory(
    () => NewCashOrderBloc(
      getMixCodesUseCase: sl(),
      getProjectsUseCase: sl(),
      createCashOrderUseCase: sl(),
    ),
  );

  // ── Invoices ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<InvoicesRemoteDataSource>(
    () => MockInvoicesRemoteDataSource(),
  );
  sl.registerLazySingleton<InvoicesLocalDataSource>(
    () => MockInvoicesLocalDataSource(),
  );
  sl.registerLazySingleton<InvoicesRepository>(
    () => InvoicesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetInvoicesUseCase(sl()));
  sl.registerLazySingleton(() => GetInvoiceDetailUseCase(sl()));
  sl.registerLazySingleton(() => DownloadInvoiceUseCase(sl()));
  sl.registerFactory(() => InvoicesBloc(getInvoicesUseCase: sl()));
  sl.registerFactory(
    () => InvoiceDetailBloc(
      getInvoiceDetailUseCase: sl(),
      downloadInvoiceUseCase: sl(),
    ),
  );

  // ── Wallet ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => MockWalletRemoteDataSource(),
  );
  sl.registerLazySingleton<WalletLocalDataSource>(
    () => MockWalletLocalDataSource(),
  );
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetWalletBalanceUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => AddFundsUseCase(sl()));
  sl.registerFactory(
    () => WalletBloc(
      getWalletBalanceUseCase: sl(),
      getTransactionsUseCase: sl(),
      addFundsUseCase: sl(),
    ),
  );

  // ── Payment ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => MockPaymentRemoteDataSource(),
  );
  sl.registerLazySingleton<PaymentLocalDataSource>(
    () => MockPaymentLocalDataSource(),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => InitiatePaymentUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPaymentUseCase(sl()));
  sl.registerFactory(
    () => PaymentBloc(
      initiatePaymentUseCase: sl(),
      verifyPaymentUseCase: sl(),
    ),
  );

  // ── Profile ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => MockProfileRemoteDataSource(),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => MockProfileLocalDataSource(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // ── Notifications ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => MockNotificationsRemoteDataSource(),
  );
  sl.registerLazySingleton<NotificationsLocalDataSource>(
    () => MockNotificationsLocalDataSource(),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllReadUseCase(sl()));
  sl.registerFactory(
    () => NotificationsBloc(
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
      markAllReadUseCase: sl(),
    ),
  );

  // ── KYC ────────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<KycRemoteDataSource>(
    () => MockKycRemoteDataSource(),
  );
  sl.registerLazySingleton<KycLocalDataSource>(
    () => MockKycLocalDataSource(),
  );
  sl.registerLazySingleton<KycRepository>(
    () => KycRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetKycStatusUseCase(sl()));
  sl.registerLazySingleton(() => SubmitKycUseCase(sl()));
  sl.registerFactory(
    () => KycBloc(
      getKycStatusUseCase: sl(),
      submitKycUseCase: sl(),
    ),
  );

  // ── Onboarding ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => MockOnboardingLocalDataSource(),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetOnboardingPagesUseCase(sl()));
  sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl()));
  sl.registerFactory(
    () => OnboardingBloc(
      getOnboardingPagesUseCase: sl(),
      completeOnboardingUseCase: sl(),
    ),
  );

  // ── Splash ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SplashLocalDataSource>(
    () => MockSplashLocalDataSource(),
  );
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetAppLaunchStateUseCase(sl()));
  sl.registerFactory(() => SplashBloc(getAppLaunchStateUseCase: sl()));
}
