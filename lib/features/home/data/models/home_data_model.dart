import '../../domain/entities/home_data.dart';

/// Data-layer model for [ActiveOrder]. Adds JSON serialisation.
class ActiveOrderModel extends ActiveOrder {
  const ActiveOrderModel({
    required super.orderId,
    super.orderReference,
    required super.status,
    required super.grade,
    required super.location,
    super.projectName,
    required super.timeSlot,
    required super.volume,
    required super.date,
    required super.amount,
    super.imageUrl,
    super.delivered,
    super.total,
  });

  /// Creates an [ActiveOrderModel] from a JSON map.
  factory ActiveOrderModel.fromJson(Map<String, dynamic> json) {
    final volumeLabel = json['volumeLabel']?.toString();
    final rawVolume = json['volume']?.toString() ?? '';
    final formattedVolume = volumeLabel != null && volumeLabel.isNotEmpty
        ? volumeLabel
        : (rawVolume.isNotEmpty ? '$rawVolume m³' : '');

    return ActiveOrderModel(
      orderId: json['orderId']?.toString() ?? '',
      orderReference: json['orderReference']?.toString(),
      status: json['status']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      location: (json['location']?.toString() ?? '').isNotEmpty
          ? json['location'].toString()
          : (json['projectName']?.toString() ?? ''),
      projectName: json['projectName']?.toString(),
      timeSlot: json['timeSlot']?.toString() ?? '',
      volume: formattedVolume,
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      delivered: (json['delivered'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );
  }

  /// Serialises this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      if (orderReference != null) 'orderReference': orderReference,
      'status': status,
      'grade': grade,
      'location': location,
      if (projectName != null) 'projectName': projectName,
      'timeSlot': timeSlot,
      'volume': volume,
      'date': date,
      'amount': amount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'delivered': delivered,
      'total': total,
    };
  }

  /// Creates an [ActiveOrderModel] from a domain [ActiveOrder] entity.
  factory ActiveOrderModel.fromEntity(ActiveOrder entity) {
    return ActiveOrderModel(
      orderId: entity.orderId,
      orderReference: entity.orderReference,
      status: entity.status,
      grade: entity.grade,
      location: entity.location,
      projectName: entity.projectName,
      timeSlot: entity.timeSlot,
      volume: entity.volume,
      date: entity.date,
      amount: entity.amount,
      imageUrl: entity.imageUrl,
      delivered: entity.delivered,
      total: entity.total,
    );
  }
}

/// Data-layer model for [HomeData]. Adds JSON serialisation.
class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.userName,
    required super.companyName,
    required super.activeOrders,
    super.projectCount,
    super.accountType,
    super.nextStep,
  });

  /// Creates a [HomeDataModel] from a JSON map.
  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final ordersJson = <dynamic>[
      ...(json['activeOrders'] as List<dynamic>? ?? const []),
      ...(json['draftOrders'] as List<dynamic>? ?? const []),
    ];
    final orders = ordersJson
        .map((e) => ActiveOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return HomeDataModel(
      // Empty accounts can legitimately return null/blank profile labels;
      // that must not turn a valid `{activeOrders: []}` response into an
      // UnexpectedFailure on the Home screen.
      userName: json['userName'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      activeOrders: orders,
      projectCount: (json['projectCount'] as num?)?.toInt() ?? 0,
      accountType: json['accountType'] as String? ?? 'individual',
      nextStep:
          (json['access'] as Map?)?['nextStep']?.toString() ??
          json['nextStep']?.toString() ??
          'home',
    );
  }

  /// Serialises this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'companyName': companyName,
      'activeOrders': activeOrders
          .map((o) => ActiveOrderModel.fromEntity(o).toJson())
          .toList(),
      'accountType': accountType,
      'nextStep': nextStep,
    };
  }

  /// Creates a [HomeDataModel] from a domain [HomeData] entity.
  factory HomeDataModel.fromEntity(HomeData entity) {
    return HomeDataModel(
      userName: entity.userName,
      companyName: entity.companyName,
      activeOrders: entity.activeOrders
          .map(ActiveOrderModel.fromEntity)
          .toList(),
      projectCount: entity.projectCount,
      accountType: entity.accountType,
      nextStep: entity.nextStep,
    );
  }
}
