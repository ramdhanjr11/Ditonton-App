import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvEmpty()) {
    on<FetchPopularTv>(_fetchPopularTv);
  }

  _fetchPopularTv(FetchPopularTv event, Emitter<PopularTvState> emit) async {
    emit(PopularTvLoading());
    var result = await _getPopularTv.execute();

    result.fold(
      (failure) {
        emit(PopularTvError(failure.message));
      },
      (data) {
        emit(PopularTvHasData(data));
      },
    );
  }
}
