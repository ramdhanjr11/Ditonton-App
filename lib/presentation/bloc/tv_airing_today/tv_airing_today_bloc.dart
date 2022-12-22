import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_airing_today.dart';
import 'package:equatable/equatable.dart';

part 'tv_airing_today_event.dart';
part 'tv_airing_today_state.dart';

class TvAiringTodayBloc extends Bloc<TvAiringTodayEvent, TvAiringTodayState> {
  final GetTvAiringToday _getTvAiringToday;
  TvAiringTodayBloc(this._getTvAiringToday) : super(TvAiringTodayEmpty()) {
    on<FetchTvAiringToday>(_fetchTvAiringToday);
  }

  _fetchTvAiringToday(
      FetchTvAiringToday event, Emitter<TvAiringTodayState> emit) async {
    emit(TvAiringTodayLoading());
    var result = await _getTvAiringToday.execute();

    result.fold(
      (failure) {
        emit(TvAiringTodayError(failure.message));
      },
      (data) {
        emit(TvAiringTodayHasData(data));
      },
    );
  }
}
