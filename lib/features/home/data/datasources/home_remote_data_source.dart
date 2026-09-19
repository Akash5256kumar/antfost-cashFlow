import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/app_demo_service.dart';
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
  final MockHomeRemoteDataSource _mockDataSource = MockHomeRemoteDataSource();

  @override
  Future<HomeDataModel> getHomeData() async {
    if (AppDemoService.isDemoMode) {
      return _mockDataSource.getHomeData();
    }
    try {
      // Fetch core home data
      final homeResponse = await _client.get<Map<String, dynamic>>('/home');
      final homeData = homeResponse.data;
      if (homeData == null) throw const ServerException('Empty home response.');

      // Fetch /me to get accountType and nextStep (since they might not be in /home)
      String accountType = 'individual';
      String nextStep = 'home';
      try {
        final meResponse = await _client.get<Map<String, dynamic>>('/me');
        if (meResponse.data != null) {
          accountType = meResponse.data!['accountType']?.toString() ?? accountType;
          nextStep = meResponse.data!['access']?['nextStep']?.toString() ?? nextStep;
        }
      } catch (_) {
        // Ignore errors for /me, fallback to defaults
      }

      // Fetch projects to get the projectCount
      var projectCount = 0;
      try {
        final projectsResponse = await _client.get<Map<String, dynamic>>(
          '/projects',
          queryParameters: const {'page': 1, 'pageSize': 1},
        );
        projectCount = (projectsResponse.data?['total'] as num?)?.toInt() ??
            ((projectsResponse.data?['items'] as List?)?.length ?? 0);
      } catch (_) {
        // Ignore errors for /projects
      }

      final activeOrders = <ActiveOrder>[];
      final items = <dynamic>[
        if (homeData['activeOrders'] is List)
          ...(homeData['activeOrders'] as List),
        if (homeData['draftOrders'] is List)
          ...(homeData['draftOrders'] as List),
      ];
      for (final item in items) {
        if (item is Map) {
          final volumeLabel = item['volumeLabel']?.toString();
          final rawVolume = item['volume']?.toString() ?? '';
          final formattedVolume = volumeLabel != null && volumeLabel.isNotEmpty
              ? volumeLabel
              : (rawVolume.isNotEmpty ? '$rawVolume m³' : '');

          activeOrders.add(ActiveOrder(
            orderId: item['orderId']?.toString() ?? '',
            orderReference: item['orderReference']?.toString(),
            status: item['status']?.toString() ??
                (item['isDraft'] == true ? 'draft' : 'scheduled'),
            grade: item['grade']?.toString() ?? '',
            location: (item['location']?.toString() ?? '').isNotEmpty
                ? item['location'].toString()
                : (item['projectName']?.toString() ?? ''),
            projectName: item['projectName']?.toString(),
            timeSlot: item['timeSlot']?.toString() ?? '',
            volume: formattedVolume,
            date: item['date']?.toString() ?? '',
            amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
            imageUrl: item['imageUrl']?.toString(),
            delivered: (item['delivered'] as num?)?.toInt(),
            total: (item['total'] as num?)?.toInt(),
          ));
        }
      }

      return HomeDataModel.fromEntity(
        HomeData(
          userName: homeData['userName']?.toString() ?? 'User',
          companyName: homeData['companyName']?.toString() ?? '',
          accountType: accountType,
          nextStep: nextStep,
          projectCount: projectCount,
          activeOrders: activeOrders,
        ),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 || AppDemoService.isDemoMode) {
        return _mockDataSource.getHomeData();
      }
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
