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
          title: 'Order Scheduled',
          message:
              'Your order has been scheduled for 10 Feb 2026, 06:00 - 14:00',
          date: '1d ago',
          isRead: false,
          category: NotificationCategory.operational,
          orderId: 'AF-2026-02-000001',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n2',
          title: 'Truck Dispatched',
          message: 'Truck has been dispatched for order AF-2026-02-000001',
          date: '1d ago',
          isRead: false,
          category: NotificationCategory.operational,
          orderId: 'AF-2026-02-000001',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n3',
          title: 'Truck Arrived',
          message: 'Truck has arrived at Marina Heights Tower 3',
          date: '23h ago',
          isRead: true,
          category: NotificationCategory.operational,
          orderId: 'AF-2026-02-000001',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n4',
          title: 'Delivery Started',
          message: 'Concrete delivery is now in progress',
          date: '23h ago',
          isRead: true,
          category: NotificationCategory.operational,
          orderId: 'AF-2026-02-000001',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n5',
          title: 'Delivery Completed',
          message: 'Order AF-2026-02-000005 has been completed successfully',
          date: '5d ago',
          isRead: true,
          category: NotificationCategory.operational,
          orderId: 'AF-2026-02-000005',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n6',
          title: 'Delay Alert',
          message: 'Restricted zone access - traffic clearance required',
          date: '19h ago',
          isRead: false,
          category: NotificationCategory.operational,
          orderId: 'AF-2026-02-000007',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n7',
          title: 'Payment Received',
          message:
              'AED 11,812.50 payment confirmed for order AF-2026-02-000001',
          date: '2d ago',
          isRead: true,
          category: NotificationCategory.financial,
          orderId: 'AF-2026-02-000001',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n8',
          title: 'Wallet Updated',
          message: 'AED 500.00 added to your wallet',
          date: '3d ago',
          isRead: true,
          category: NotificationCategory.financial,
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n9',
          title: 'VAT Invoice Ready',
          message: 'Tax invoice is now available for order AF-2026-02-000002',
          date: '2d ago',
          isRead: true,
          category: NotificationCategory.financial,
          orderId: 'AF-2026-02-000002',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n10',
          title: 'Refund Processed',
          message: 'AED 9,187.50 refunded for cancelled order AF-2026-02-000008',
          date: '02 Feb',
          isRead: true,
          category: NotificationCategory.financial,
          orderId: 'AF-2026-02-000008',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n11',
          title: 'Allocation Delayed',
          message: 'Resource allocation delayed due to high demand',
          date: '21h ago',
          isRead: false,
          category: NotificationCategory.risk,
          orderId: 'AF-2026-02-000007',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n12',
          title: 'Restricted Zone Delay',
          message: 'Delivery delayed - restricted zone access approval pending',
          date: '19h ago',
          isRead: false,
          category: NotificationCategory.risk,
          orderId: 'AF-2026-02-000007',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n13',
          title: 'Payment Verification Pending',
          message: 'Payment verification in progress for order AF-2026-02-000006',
          date: '1d ago',
          isRead: true,
          category: NotificationCategory.risk,
          orderId: 'AF-2026-02-000006',
        ),
      ),
      AppNotificationModel.fromEntity(
        const AppNotification(
          id: 'n14',
          title: 'Coordinator Assigned',
          message:
              'Ahmed Al Mansouri will contact you regarding large-volume order',
          date: '4d ago',
          isRead: true,
          category: NotificationCategory.risk,
          orderId: 'AF-2026-02-000004',
        ),
      ),
    ];
  }
}
