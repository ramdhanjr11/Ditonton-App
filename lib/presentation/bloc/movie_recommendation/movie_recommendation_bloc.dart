import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations)
      : super(MovieRecommendationEmpty()) {
    on<FetchMovieRecommendation>(_fetchMovieRecommendation);
  }

  _fetchMovieRecommendation(FetchMovieRecommendation event,
      Emitter<MovieRecommendationState> emit) async {
    emit(MovieRecommendationLoading());
    var result = await _getMovieRecommendations.execute(event.id);

    result.fold(
      (failure) {
        emit(MovieRecommendationError(failure.message));
      },
      (data) {
        emit(MovieRecommendationHasData(data));
      },
    );
  }
}
