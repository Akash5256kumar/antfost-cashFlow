import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
}
