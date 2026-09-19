import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/di/injection.dart';
import '../services/device_api_service.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';

import '../../app/navigation/app_router.dart';
import '../../app/navigation/app_routes.dart';

/// Configures Firebase Cloud Messaging for customer-facing push notifications.
///
/// Firebase is used only to receive notifications. Business data, orders,
/// payments, wallet values, and KYC records remain owned by their APIs.
class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_openNotifications);
    _messaging.onTokenRefresh.listen((_) => registerDeviceToken());

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _openNotifications(initialMessage),
      );
    }
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    AppRouter.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text([title, body].whereType<String>().join('\n')),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _openNotifications(message),
        ),
      ),
    );
  }

  void _openNotifications(RemoteMessage message) {
    AppRouter.navigatorKey.currentState?.pushNamed(AppRoutes.notifications);
  }

  /// Registers the current Firebase token with our backend.
  /// Should be called after successful sign-in, and whenever Firebase rotates the token.
  Future<void> registerDeviceToken() async {
    try {
      final auth = sl<AuthLocalDataSource>();
      try {
        await auth.getCachedUser();
      } catch (_) {
        return;
      }

      final token = await getToken();
      if (token == null) return;

      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();

      String platform = 'unknown';
      String deviceName = 'unknown';

      if (Platform.isAndroid) {
        platform = 'android';
        final info = await deviceInfo.androidInfo;
        deviceName = info.model;
      } else if (Platform.isIOS) {
        platform = 'ios';
        final info = await deviceInfo.iosInfo;
        deviceName = info.name;
      }

      await sl<DeviceApiService>().registerDevice(
        token: token,
        platform: platform,
        deviceName: deviceName,
        appVersion: packageInfo.version,
      );
    } catch (_) {
      // Ignore if registration fails (e.g. network error)
    }
  }

  /// Removes the device token from our backend.
  /// Should be called during sign-out.
  Future<void> removeDeviceToken() async {
    try {
      final token = await getToken();
      if (token == null) return;
      await sl<DeviceApiService>().removeDevice(token);
    } catch (_) {
      // Ignore
    }
  }
}
