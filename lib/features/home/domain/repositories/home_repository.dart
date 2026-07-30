import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_data.dart';

/// Contract for the home feature data layer.
abstract class HomeRepository {
  /// Returns aggregated home screen data or a [Failure].
  Future<Either<Failure, HomeData>> getHomeData();
}
