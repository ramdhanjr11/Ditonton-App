import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_recommendation_event.dart';
part 'tv_recommendation_state.dart';

class TvRecommendationBloc
    extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetTvRecommendations _getTvRecommendations;

  TvRecommendationBloc(this._getTvRecommendations)
      : super(TvRecommendationEmpty()) {
    on<FetchTvRecommendation>(_fetchTvRecommendation);
  }

  _fetchTvRecommendation(
      FetchTvRecommendation event, Emitter<TvRecommendationState> emit) async {
    emit(TvRecommendationLoading());
    var result = await _getTvRecommendations.execute(event.id);

    result.fold(
      (failure) {
        emit(TvRecommendationError(failure.message));
      },
      (data) {
        emit(TvRecommendationHasData(data));
      },
    );
  }
}
