import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/notification.dart';
import '../models/notification_model.dart';

/// Contract for the notifications remote data source.
abstract class NotificationsRemoteDataSource {
  /// Fetches all notifications from the API.
  ///
  /// Throws [ServerException] on failure.
  Future<List<AppNotificationModel>> getNotifications();
}

/// Mock implementation that returns hard-coded dummy data after 300 ms.
///
/// Replace with a real Dio/Retrofit implementation once the backend is ready.
class MockNotificationsRemoteDataSource
    implements NotificationsRemoteDataSource {
  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n1',
          title: 'Order Confirmed',
          message:
              'Your order AF-2024-02-000001 has been confirmed.',
          date: '7 Feb 2026 10:08 AM',
          isRead: false,
          type: NotificationType.order,
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n2',
          title: 'Payment Received',
          message:
              'Payment of AED 17,400 received for order AF-2024-02-000001.',
          date: '7 Feb 2026 09:00 AM',
          isRead: true,
          type: NotificationType.payment,
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n3',
          title: 'Delivery Update',
          message: 'First batch of 10 m³ delivered to Marina Tower.',
          date: '7 Feb 2026 08:30 AM',
          isRead: false,
          type: NotificationType.order,
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n4',
          title: 'KYC Approved',
          message: 'Your KYC verification has been approved.',
          date: '1 Feb 2026 02:00 PM',
          isRead: true,
          type: NotificationType.kyc,
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n5',
          title: 'Welcome to AntFost',
          message: 'Start ordering concrete instantly.',
          date: '25 Jan 2026 10:00 AM',
          isRead: true,
          type: NotificationType.system,
        ),
      ),
    ];
  }
}
