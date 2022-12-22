import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;
  TvDetailBloc(this._getTvDetail) : super(TvDetailEmpty()) {
    on<FetchTvDetail>(_fetchTvDetail);
  }

  _fetchTvDetail(FetchTvDetail event, Emitter<TvDetailState> emit) async {
    emit(TvDetailLoading());
    var result = await _getTvDetail.execute(event.id);

    result.fold(
      (failure) {
        emit(TvDetailError(failure.message));
      },
      (data) {
        emit(TvDetailHasData(data));
      },
    );
  }
}
