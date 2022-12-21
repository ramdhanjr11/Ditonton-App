import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_watchlist_status_event.dart';
part 'movie_watchlist_status_state.dart';

class MovieWatchlistStatusBloc
    extends Bloc<MovieWatchlistStatusEvent, MovieWatchlistStatusState> {
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetWatchListStatus _getWatchListStatus;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  MovieWatchlistStatusBloc(
    this._saveWatchlist,
    this._removeWatchlist,
    this._getWatchListStatus,
  ) : super(MovieWatchlistStatus(false, ' ')) {
    on<FetchMovieWatchlistStatus>(_fetchMovieWatchlistStatus);
    on<AddWatchlist>(_addWatchlist);
    on<DeleteWatchlist>(_deleteWatchlist);
  }

  _fetchMovieWatchlistStatus(FetchMovieWatchlistStatus event,
      Emitter<MovieWatchlistStatusState> emit) async {
    var result = await _getWatchListStatus.execute(event.id);
    _isAddedtoWatchlist = result;
    emit(MovieWatchlistStatus(result, ''));
  }

  _addWatchlist(
      AddWatchlist event, Emitter<MovieWatchlistStatusState> emit) async {
    emit(MovieWatchlistLoading());
    var result = await _saveWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(MovieWatchlistError(failure.message));
      },
      (message) {
        _isAddedtoWatchlist = true;
        emit(MovieWatchlistStatus(true, message));
      },
    );
  }

  _deleteWatchlist(
      DeleteWatchlist event, Emitter<MovieWatchlistStatusState> emit) async {
    emit(MovieWatchlistLoading());
    var result = await _removeWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(MovieWatchlistError(failure.message));
      },
      (message) {
        _isAddedtoWatchlist = false;
        emit(MovieWatchlistStatus(false, message));
      },
    );
  }
}
