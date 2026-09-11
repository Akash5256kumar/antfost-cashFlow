import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_client.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/home_data.dart';
import '../models/home_data_model.dart';

/// Contract for the home remote data source.
abstract class HomeRemoteDataSource {
  /// Fetches home data from the remote API.
  ///
  /// Throws [ServerException] on failure.
  Future<HomeDataModel> getHomeData();
}

/// Mock implementation that returns hard-coded dummy data after 300 ms.
///
/// Replace with a real Dio/Retrofit implementation once the backend is ready.
class MockHomeRemoteDataSource implements HomeRemoteDataSource {
  @override
  Future<HomeDataModel> getHomeData() async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return HomeDataModel.fromEntity(
      const HomeData(
        userName: 'Rashed',
        companyName: 'Rashed Construction',
        activeOrders: [
          ActiveOrder(
            orderId: 'AF-2052',
            status: 'scheduled',
            grade: 'C25/30',
            location: 'Marina Tower',
            timeSlot: '6 AM - 10 AM (±4 hrs)',
            volume: '42 m³',
            date: 'May 16, 2025',
            amount: 17400.0,
          ),
          ActiveOrder(
            orderId: 'AF-2048',
            status: 'inProgress',
            grade: 'C30/37',
            location: 'Palm Jumeirah Villa',
            timeSlot: '6 AM - 12 PM (±6 hrs)',
            volume: '28 m³',
            date: 'May 15, 2025',
            amount: 9450.0,
          ),
          ActiveOrder(
            orderId: 'AF-2043',
            status: 'confirmationNeeded',
            grade: 'C35/45',
            location: 'Creek Residence',
            timeSlot: '8 AM - 2 PM (±6 hrs)',
            volume: '120 m³',
            date: 'May 14, 2025',
            amount: 42850.0,
          ),
        ],
      ),
    );
  }
}

/// Mobile API implementation for the Home screen.
class ApiHomeRemoteDataSource implements HomeRemoteDataSource {
  ApiHomeRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<HomeDataModel> getHomeData() async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/home');
      final data = response.data;
      if (data == null) throw const ServerException('Empty home response.');
      var projectCount = 0;
      try {
        final projects = await _client.get<Map<String, dynamic>>(
          '/projects',
          queryParameters: const {'page': 1, 'pageSize': 1},
        );
        projectCount =
            (projects.data?['total'] as num?)?.toInt() ??
            ((projects.data?['items'] as List?)?.length ?? 0);
      } on DioException catch (error) {
        final body = error.response?.data;
        if (error.response?.statusCode != 404 ||
            body is! Map ||
            body['code'] != 'NO_PROJECTS_FOUND')
          rethrow;
      }
      return HomeDataModel.fromJson({...data, 'projectCount': projectCount});
    } on DioException catch (error) {
      final body = error.response?.data;
      final message = body is Map && body['message'] is String
          ? body['message'] as String
          : error.message ?? 'Unable to load home data.';
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
