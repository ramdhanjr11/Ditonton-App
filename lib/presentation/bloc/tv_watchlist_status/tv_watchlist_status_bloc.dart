import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'tv_watchlist_status_event.dart';
part 'tv_watchlist_status_state.dart';

class TvWatchlistStatusBloc
    extends Bloc<TvWatchlistStatusEvent, TvWatchlistStatusState> {
  final GetTvWatchListStatus _getTvWatchListStatus;
  final SaveTvWatchlist _saveTvWatchlist;
  final RemoveTvWatchlist _removeTvWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  TvWatchlistStatusBloc(
    this._getTvWatchListStatus,
    this._saveTvWatchlist,
    this._removeTvWatchlist,
  ) : super(TvWatchlistStatus(false, '')) {
    on<FetchTvWatchlistStatus>(_fetchTvWatchlistStatus);
    on<AddWatchlist>(_addTvWatchlist);
    on<DeleteWatchlist>(_deleteTvWatchlist);
  }

  _fetchTvWatchlistStatus(FetchTvWatchlistStatus event,
      Emitter<TvWatchlistStatusState> emit) async {
    var result = await _getTvWatchListStatus.execute(event.id);
    _isAddedtoWatchlist = result;
    emit(TvWatchlistStatus(result, ''));
  }

  _addTvWatchlist(
      AddWatchlist event, Emitter<TvWatchlistStatusState> emit) async {
    emit(TvWatchlistStatusLoading());
    var result = await _saveTvWatchlist.execute(event.tv);

    result.fold(
      (failure) {
        emit(TvWatchlistStatusError(failure.message));
      },
      (successMessage) {
        _isAddedtoWatchlist = true;
        emit(TvWatchlistStatus(true, successMessage));
      },
    );
  }

  _deleteTvWatchlist(
      DeleteWatchlist event, Emitter<TvWatchlistStatusState> emit) async {
    emit(TvWatchlistStatusLoading());
    var result = await _removeTvWatchlist.execute(event.tv);

    result.fold(
      (failure) {
        emit(TvWatchlistStatusError(failure.message));
      },
      (successMessage) {
        _isAddedtoWatchlist = false;
        emit(TvWatchlistStatus(false, successMessage));
      },
    );
  }
}
