import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/di/injection.dart';
import 'app/navigation/app_router.dart';
import 'app/navigation/app_routes.dart';
import 'core/notifications/firebase_notification_service.dart';
import 'core/services/api_client.dart';
import 'core/services/secure_storage_service.dart';
import 'core/widgets/connectivity_guard.dart';
import 'core/widgets/debug_upgrade_prompt.dart';
import 'app/config/app_breakpoints.dart';
import 'app/config/app_strings.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/invoices/presentation/bloc/invoice_detail_bloc.dart';
import 'features/invoices/presentation/bloc/invoices_bloc.dart';
import 'features/kyc/presentation/bloc/kyc_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/orders/presentation/bloc/new_cash_order_bloc.dart';
import 'features/orders/presentation/bloc/orders_bloc.dart';
import 'features/payment/presentation/bloc/payment_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseNotificationService.instance.initialize();
  await initDependencies();
  await sl<ApiClient>().restoreAccessToken();
  if (kDebugMode) {
    final token = await sl<SecureStorageService>().readAccessToken();
    debugPrint('[AUTH] Splash access token: ${token ?? '(none)'}');
  }
  runApp(AntfostApp());
}

class AntfostApp extends StatelessWidget {
  const AntfostApp({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
    create: (_) => sl<AuthBloc>(),
    child: const _SessionScopedApp(),
  );
}

/// Recreates every account-scoped BLoC after logout. Tokens alone are not
/// enough: BLoCs retain their last response in memory until they are disposed.
class _SessionScopedApp extends StatefulWidget {
  const _SessionScopedApp();

  @override
  State<_SessionScopedApp> createState() => _SessionScopedAppState();
}

class _SessionScopedAppState extends State<_SessionScopedApp> {
  int _sessionGeneration = 0;

  void _clearSessionUi() {
    setState(() => _sessionGeneration++);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppRouter.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.signIn,
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, state) => state is AuthSignedOut,
      listener: (context, state) => _clearSessionUi(),
      child: KeyedSubtree(
        key: ValueKey(_sessionGeneration),
        child: _buildSessionApp(context),
      ),
    );
  }

  Widget _buildSessionApp(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (_) => sl<SplashBloc>()),
        BlocProvider<OnboardingBloc>(create: (_) => sl<OnboardingBloc>()),
        BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
        BlocProvider<OrdersBloc>(create: (_) => sl<OrdersBloc>()),
        BlocProvider<NewCashOrderBloc>(create: (_) => sl<NewCashOrderBloc>()),
        BlocProvider<InvoicesBloc>(create: (_) => sl<InvoicesBloc>()),
        BlocProvider<InvoiceDetailBloc>(create: (_) => sl<InvoiceDetailBloc>()),
        BlocProvider<WalletBloc>(create: (_) => sl<WalletBloc>()),
        BlocProvider<PaymentBloc>(create: (_) => sl<PaymentBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<NotificationsBloc>(create: (_) => sl<NotificationsBloc>()),
        BlocProvider<KycBloc>(create: (_) => sl<KycBloc>()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        navigatorKey: AppRouter.navigatorKey,
        scaffoldMessengerKey: AppRouter.scaffoldMessengerKey,
        theme: AppTheme.light(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        locale: DevicePreview.locale(context),
        builder: (context, child) {
          final cappedChild = ColoredBox(
            color: AppColors.white,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.tablet,
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
          return DevicePreview.appBuilder(
            context,
            ConnectivityGuard(
              child: DelayedUpgradeAlert(
                navigatorKey: AppRouter.navigatorKey,
                child: cappedChild,
              ),
            ),
          );
        },
      ),
    );
  }
}
