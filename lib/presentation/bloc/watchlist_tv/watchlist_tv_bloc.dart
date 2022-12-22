import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;

  WatchlistTvBloc(this._getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>(_fetchWatchlistTv);
  }

  _fetchWatchlistTv(
      FetchWatchlistTv event, Emitter<WatchlistTvState> emit) async {
    emit(WatchlistTvLoading());
    var result = await _getWatchlistTv.execute();

    result.fold(
      (failure) {
        emit(WatchlistTvError(failure.message));
      },
      (data) {
        emit(WatchlistTvHasData(data));
      },
    );
  }
}
