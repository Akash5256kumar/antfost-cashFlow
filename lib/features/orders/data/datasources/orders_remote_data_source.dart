import '../../../../core/errors/exceptions.dart';
import '../models/mix_code_model.dart';
import '../models/order_model.dart';
import '../models/project_model.dart';
import '../../domain/entities/new_cash_order_request.dart';
import '../../domain/entities/order.dart';

/// Contract for the remote data source used by [OrdersRepositoryImpl].
abstract class OrdersRemoteDataSource {
  /// Fetches the full order list from the remote API.
  /// Throws [ServerException] on failure.
  Future<List<OrderModel>> getOrders();

  /// Fetches a single order by [orderId] from the remote API.
  /// Throws [ServerException] on failure.
  Future<OrderModel> getOrderDetails(String orderId);

  /// Fetches the concrete mix code catalogue from the remote API.
  /// Throws [ServerException] on failure.
  Future<List<MixCodeModel>> getMixCodes();

  /// Fetches the user's saved projects from the remote API.
  /// Throws [ServerException] on failure.
  Future<List<ProjectModel>> getProjects();

  /// Persists a new project on the remote API.
  /// Throws [ServerException] on failure.
  Future<ProjectModel> addProject(ProjectModel project);

  /// Submits a new cash order to the remote API and returns the created order.
  /// Throws [ServerException] on failure.
  Future<OrderModel> createCashOrder(NewCashOrderRequest request);
}

/// Mock implementation that returns static dummy data after a 300 ms delay.
/// Used while the real backend is not yet available.
class MockOrdersRemoteDataSource implements OrdersRemoteDataSource {
  // ── Dummy orders ──────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _ordersJson = [
    {
      'orderId': 'AF-2024-02-000001',
      'status': 'inProgress',
      'grade': 'C25/30',
      'location': 'Marina Tower - Ground Floor',
      'timeSlot': '6 AM - 10 AM (±4 hrs)',
      'volume': '50 m³ · 5 trips',
      'date': '7 Feb, 10:06 AM',
      'amount': 17400.0,
      'delivered': 20,
      'total': 50,
    },
    {
      'orderId': 'AF-2024-02-000002',
      'status': 'scheduled',
      'grade': 'C30/37',
      'location': 'Palm Villa Site A',
      'timeSlot': '6 AM - 12 PM (±6 hrs)',
      'volume': '25 m³ · 3 trips',
      'date': '6 Feb, 12:06 PM',
      'amount': 9450.0,
    },
    {
      'orderId': 'AF-2024-02-000003',
      'status': 'completed',
      'grade': 'C30/37',
      'location': 'Palm Villa Site A',
      'timeSlot': '',
      'volume': '',
      'date': '6 Feb, 12:06 PM',
      'amount': 9450.0,
    },
  ];

  // ── Dummy mix codes ───────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _mixCodesJson = [
    {'code': 'C20/25', 'type': 'Standard Mix', 'pricePerM3': 380.0},
    {'code': 'C25/30', 'type': 'Standard Mix', 'pricePerM3': 450.0},
    {'code': 'C30/37', 'type': 'High Strength', 'pricePerM3': 520.0},
    {'code': 'C35/45', 'type': 'High Strength', 'pricePerM3': 610.0},
  ];

  // ── Dummy projects ────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _projectsJson = [
    {'id': 'p1', 'name': 'Marina Tower', 'location': 'Dubai Marina'},
    {'id': 'p2', 'name': 'Palm Villa', 'location': 'Palm Jumeirah'},
  ];

  // ── Helper ────────────────────────────────────────────────────────────────

  /// Simulates network latency.
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));

  // ── Interface implementation ──────────────────────────────────────────────

  @override
  Future<List<OrderModel>> getOrders() async {
    await _delay();
    return _ordersJson.map(OrderModel.fromJson).toList();
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    await _delay();
    final json = _ordersJson.firstWhere(
      (o) => o['orderId'] == orderId,
      orElse: () => throw const ServerException(
        'Order not found.',
      ),
    );
    return OrderModel.fromJson(json);
  }

  @override
  Future<List<MixCodeModel>> getMixCodes() async {
    await _delay();
    return _mixCodesJson.map(MixCodeModel.fromJson).toList();
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    await _delay();
    return _projectsJson.map(ProjectModel.fromJson).toList();
  }

  @override
  Future<ProjectModel> addProject(ProjectModel project) async {
    await _delay();
    // In a real implementation this would send a POST request and return the
    // server-assigned entity. Here we echo back the same project.
    return project;
  }

  @override
  Future<OrderModel> createCashOrder(NewCashOrderRequest request) async {
    await _delay();
    return const OrderModel(
      orderId: 'AF-NEW-001',
      status: OrderStatusType.scheduled,
      grade: 'C25/30',
      location: 'New Project Site',
      timeSlot: '6 AM - 10 AM',
      volume: '0 m³ · 0 trips',
      date: 'Pending',
      amount: 0.0,
    );
  }
}
