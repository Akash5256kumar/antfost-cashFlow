import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/app_demo_service.dart';
import '../../../../core/services/order_api_service.dart';
import '../../../../app/di/injection.dart';
import 'package:dio/dio.dart';
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
  Future<List<MixCodeModel>> getMixCodes(String projectId, String locationId);

  /// Fetches the available delivery time slots.
  /// Throws [ServerException] on failure.
  Future<List<Map<String, dynamic>>> getTimeWindows({
    required String projectId,
    required String locationId,
    required String mixCode,
    required double quantityM3,
    required String date,
  });

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
  Future<List<MixCodeModel>> getMixCodes(String projectId, String locationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      MixCodeModel(
        code: 'C40/50',
        type: 'Standard Mix',
        pricePerM3: 420.0,
      ),
      MixCodeModel(
        code: 'C30/37',
        type: 'Standard Mix',
        pricePerM3: 350.0,
      ),
      MixCodeModel(
        code: 'C25/30',
        type: 'Economy Mix',
        pricePerM3: 290.0,
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getTimeWindows({
    required String projectId,
    required String locationId,
    required String mixCode,
    required double quantityM3,
    required String date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'id': '1', 'startTime': '08:00 AM', 'endTime': '10:30 AM', 'available': true},
      {'id': '2', 'startTime': '11:00 AM', 'endTime': '01:30 PM', 'available': true},
      {'id': '3', 'startTime': '02:00 PM', 'endTime': '04:30 PM', 'available': true},
    ];
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

/// Mobile API implementation. The order and catalogue flows remain separate;
/// this class also supplies the live Projects list used by the current UI.
class ApiOrdersRemoteDataSource implements OrdersRemoteDataSource {
  ApiOrdersRemoteDataSource(this._client);

  final ApiClient _client;
  final MockOrdersRemoteDataSource _legacyFlowFallback =
      MockOrdersRemoteDataSource();

  @override
  Future<List<ProjectModel>> getProjects() async {
    if (AppDemoService.isDemoMode) {
      return _legacyFlowFallback.getProjects();
    }
    try {
      return await _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/projects',
          queryParameters: const {'page': 1, 'pageSize': 100},
        );
        final data = response.data;
        final items = data?['items'];
        if (items is! List)
          throw const ServerException('Projects response is invalid.');
        return items
            .whereType<Map>()
            .map((item) => ProjectModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      });
    } catch (_) {
      if (AppDemoService.isDemoMode) return _legacyFlowFallback.getProjects();
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    if (AppDemoService.isDemoMode) {
      return _legacyFlowFallback.getOrders();
    }
    try {
      return await _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders',
          queryParameters: const {'page': 1, 'pageSize': 100},
        );
        final items = response.data?['items'];
        if (items is! List)
          throw const ServerException('Orders response is invalid.');
        return items
            .whereType<Map>()
            .map((item) => OrderModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      });
    } on ServerException catch (error) {
      if (error.message == 'No orders match the selected filters.') return [];
      if (AppDemoService.isDemoMode) return _legacyFlowFallback.getOrders();
      rethrow;
    } catch (_) {
      if (AppDemoService.isDemoMode) return _legacyFlowFallback.getOrders();
      rethrow;
    }
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    if (AppDemoService.isDemoMode) {
      return _legacyFlowFallback.getOrderDetails(orderId);
    }
    try {
      return await _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders/$orderId',
        );
        if (response.data == null)
          throw const ServerException('Order details response is invalid.');
        return OrderModel.fromJson(response.data!);
      });
    } catch (_) {
      if (AppDemoService.isDemoMode) {
        return _legacyFlowFallback.getOrderDetails(orderId);
      }
      rethrow;
    }
  }

  @override
  Future<List<MixCodeModel>> getMixCodes(String projectId, String locationId) => _request(() async {
    final items = await sl<OrderApiService>().mixCodes(
      projectId: projectId,
      locationId: locationId,
    );
    return items.map((item) => MixCodeModel.fromJson(item)).toList();
  });

  @override
  Future<List<Map<String, dynamic>>> getTimeWindows({
    required String projectId,
    required String locationId,
    required String mixCode,
    required double quantityM3,
    required String date,
  }) => _request(() async {
    return sl<OrderApiService>().timeWindows(
      projectId: projectId,
      locationId: locationId,
      mixCode: mixCode,
      quantityM3: quantityM3,
      date: date,
    );
  });

  @override
  Future<ProjectModel> addProject(ProjectModel project) =>
      _legacyFlowFallback.addProject(project);

  @override
  Future<OrderModel> createCashOrder(NewCashOrderRequest request) =>
      _legacyFlowFallback.createCashOrder(request);

  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final body = error.response?.data;
      final message = body is Map && body['message'] is String
          ? body['message'] as String
          : error.message ?? 'Unable to load projects.';
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw TimeoutException(message);
      }
      if (error.type == DioExceptionType.connectionError) {
        throw NetworkException(message);
      }
      throw ServerException(message);
    }
  }
}
