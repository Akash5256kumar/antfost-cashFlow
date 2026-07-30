import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_home_data_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC that manages home screen state.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({required this.getHomeDataUseCase}) : super(const HomeInitial()) {
    on<FetchHomeDataEvent>(_onFetchHomeData);
    on<RetryHomeEvent>(_onRetryHome);
  }

  /// Handles [FetchHomeDataEvent]: loads home data and emits the result.
  Future<void> _onFetchHomeData(
    FetchHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await getHomeDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeSuccess(data)),
    );
  }

  /// Handles [RetryHomeEvent] by re-running the same fetch logic.
  Future<void> _onRetryHome(
    RetryHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _onFetchHomeData(const FetchHomeDataEvent(), emit);
  }
}
