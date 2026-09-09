import '../../../../core/errors/exceptions.dart';
import '../../../../core/mock_api/local_api_fixtures.dart';
import '../models/mix_code_model.dart';
import '../models/order_model.dart';
import '../models/project_model.dart';
import '../../domain/entities/new_cash_order_request.dart';

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
      'orderId': 'AF-2052',
      'status': 'scheduled',
      'grade': 'C25/30',
      'location': 'Marina Tower',
      'timeSlot': '6 AM - 10 AM (±4 hrs)',
      'volume': '42 m³',
      'date': 'May 16, 2025',
      'amount': 17400.0,
      'delivered': 0,
      'total': 42,
    },
    {
      'orderId': 'AF-2048',
      'status': 'inProgress',
      'grade': 'C30/37',
      'location': 'Palm Jumeirah Villa',
      'timeSlot': '6 AM - 12 PM (±6 hrs)',
      'volume': '28 m³',
      'date': 'May 15, 2025',
      'amount': 9450.0,
      'delivered': 10,
      'total': 28,
    },
    {
      'orderId': 'AF-2043',
      'status': 'inProgress',
      'grade': 'C30/37',
      'location': 'Creek Residence',
      'timeSlot': '',
      'volume': '120 m³',
      'date': 'May 14, 2025',
      'amount': 25000.0,
      'delivered': 0,
      'total': 120,
    },
    {
      'orderId': 'AF-2031',
      'status': 'completed',
      'grade': 'C30/37',
      'location': 'JVC Townhouse',
      'timeSlot': '',
      'volume': '18 m³',
      'date': 'May 12, 2025',
      'amount': 6500.0,
      'delivered': 18,
      'total': 18,
    },
    {
      'orderId': 'AF-2065',
      'status': 'draft',
      'grade': 'C30/37',
      'location': 'Palm Jumeirah Villa',
      'timeSlot': '6 AM - 12 PM (±6 hrs)',
      'volume': '120 m³',
      'date': 'May 17, 2025',
      'amount': 25000.0,
      'delivered': 0,
      'total': 120,
    },
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
      orElse: () => throw const ServerException('Order not found.'),
    );
    return OrderModel.fromJson(json);
  }

  @override
  Future<List<MixCodeModel>> getMixCodes() async {
    await _delay();
    final items = LocalApiFixtures.mixCodesResponse['items'] as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(MixCodeModel.fromJson)
        .toList();
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    await _delay();
    final items = LocalApiFixtures.projectsResponse['items'] as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(ProjectModel.fromJson)
        .toList();
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
    return OrderModel.fromJson(LocalApiFixtures.createDraftOrder(request));
  }
}
