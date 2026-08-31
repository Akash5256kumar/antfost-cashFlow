import '../../domain/entities/notification.dart';

/// Data-layer model for [AppNotification]. Adds JSON serialisation.
class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.date,
    required super.isRead,
    required super.category,
    super.orderId,
  });

  // ---------------------------------------------------------------------------
  // JSON helpers
  // ---------------------------------------------------------------------------

  /// Maps a [NotificationCategory] to its JSON string representation.
  static String _categoryToString(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.operational:
        return 'operational';
      case NotificationCategory.financial:
        return 'financial';
      case NotificationCategory.risk:
        return 'risk';
    }
  }

  /// Parses a JSON string into a [NotificationCategory].
  ///
  /// Falls back to [NotificationCategory.operational] for unknown values.
  static NotificationCategory _categoryFromString(String value) {
    switch (value) {
      case 'financial':
        return NotificationCategory.financial;
      case 'risk':
        return NotificationCategory.risk;
      case 'operational':
      default:
        return NotificationCategory.operational;
    }
  }

  /// Creates an [AppNotificationModel] from a JSON map.
  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      date: json['date'] as String,
      isRead: json['isRead'] as bool,
      category: _categoryFromString(json['category'] as String),
      orderId: json['orderId'] as String?,
    );
  }

  /// Serialises this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date,
      'isRead': isRead,
      'category': _categoryToString(category),
      'orderId': orderId,
    };
  }

  /// Creates an [AppNotificationModel] from a domain [AppNotification] entity.
  factory AppNotificationModel.fromEntity(AppNotification entity) {
    return AppNotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      date: entity.date,
      isRead: entity.isRead,
      category: entity.category,
      orderId: entity.orderId,
    );
  }

  /// Returns a copy of this model with [isRead] set to `true`.
  AppNotificationModel copyWithRead() {
    return AppNotificationModel(
      id: id,
      title: title,
      message: message,
      date: date,
      isRead: true,
      category: category,
      orderId: orderId,
    );
  }
}
