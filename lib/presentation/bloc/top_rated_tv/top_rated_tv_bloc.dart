import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTvTopRated _getTvTopRated;

  TopRatedTvBloc(this._getTvTopRated) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>(_fetchTopRatedTv);
  }

  _fetchTopRatedTv(FetchTopRatedTv event, Emitter<TopRatedTvState> emit) async {
    emit(TopRatedTvLoading());
    var result = await _getTvTopRated.execute();

    result.fold(
      (failure) {
        emit(TopRatedTvError(failure.message));
      },
      (data) {
        emit(TopRatedTvHasData(data));
      },
    );
  }
}
