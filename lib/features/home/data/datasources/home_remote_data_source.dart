import '../../../../core/errors/exceptions.dart';
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
        userName: 'Omar',
        companyName: 'Omar Construction',
        activeOrders: [
          ActiveOrder(
            orderId: 'AF-2024-02-000001',
            status: 'inProgress',
            grade: 'C25/30',
            location: 'Marina Tower - Ground Floor',
            timeSlot: '6 AM - 10 AM (±4 hrs)',
            volume: '50 m³ • 5 trips',
            date: '7 Feb, 10:06 AM',
            amount: 17400.0,
            delivered: 20,
            total: 50,
          ),
          ActiveOrder(
            orderId: 'AF-2024-02-000002',
            status: 'scheduled',
            grade: 'C30/37',
            location: 'Palm Villa Site A',
            timeSlot: '6 AM - 12 PM (±6 hrs)',
            volume: '25 m³ • 3 trips',
            date: '6 Feb, 12:06 PM',
            amount: 9450.0,
          ),
        ],
      ),
    );
  }
}
