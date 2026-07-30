import '../../domain/entities/notification.dart';

/// Data-layer model for [AppNotification]. Adds JSON serialisation.
class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.date,
    required super.isRead,
    required super.type,
  });

  // ---------------------------------------------------------------------------
  // JSON helpers
  // ---------------------------------------------------------------------------

  /// Maps a [NotificationType] to its JSON string representation.
  static String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return 'order';
      case NotificationType.payment:
        return 'payment';
      case NotificationType.system:
        return 'system';
      case NotificationType.kyc:
        return 'kyc';
    }
  }

  /// Parses a JSON string into a [NotificationType].
  ///
  /// Falls back to [NotificationType.system] for unknown values.
  static NotificationType _typeFromString(String value) {
    switch (value) {
      case 'order':
        return NotificationType.order;
      case 'payment':
        return NotificationType.payment;
      case 'kyc':
        return NotificationType.kyc;
      case 'system':
      default:
        return NotificationType.system;
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
      type: _typeFromString(json['type'] as String),
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
      'type': _typeToString(type),
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
      type: entity.type,
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
      type: type,
    );
  }
}
