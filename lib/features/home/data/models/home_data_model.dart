import '../../domain/entities/home_data.dart';

/// Data-layer model for [ActiveOrder]. Adds JSON serialisation.
class ActiveOrderModel extends ActiveOrder {
  const ActiveOrderModel({
    required super.orderId,
    required super.status,
    required super.grade,
    required super.location,
    required super.timeSlot,
    required super.volume,
    required super.date,
    required super.amount,
    super.delivered,
    super.total,
  });

  /// Creates an [ActiveOrderModel] from a JSON map.
  factory ActiveOrderModel.fromJson(Map<String, dynamic> json) {
    return ActiveOrderModel(
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      grade: json['grade'] as String,
      location: json['location'] as String,
      timeSlot: json['timeSlot'] as String,
      volume: json['volume'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      delivered: json['delivered'] as int?,
      total: json['total'] as int?,
    );
  }

  /// Serialises this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'grade': grade,
      'location': location,
      'timeSlot': timeSlot,
      'volume': volume,
      'date': date,
      'amount': amount,
      'delivered': delivered,
      'total': total,
    };
  }

  /// Creates an [ActiveOrderModel] from a domain [ActiveOrder] entity.
  factory ActiveOrderModel.fromEntity(ActiveOrder entity) {
    return ActiveOrderModel(
      orderId: entity.orderId,
      status: entity.status,
      grade: entity.grade,
      location: entity.location,
      timeSlot: entity.timeSlot,
      volume: entity.volume,
      date: entity.date,
      amount: entity.amount,
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
  });

  /// Creates a [HomeDataModel] from a JSON map.
  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final ordersJson = json['activeOrders'] as List<dynamic>? ?? [];
    final orders = ordersJson
        .map((e) => ActiveOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return HomeDataModel(
      userName: json['userName'] as String,
      companyName: json['companyName'] as String,
      activeOrders: orders,
      projectCount: (json['projectCount'] as num?)?.toInt() ?? 0,
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
    );
  }
}
