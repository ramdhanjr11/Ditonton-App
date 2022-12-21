part of 'movie_watchlist_status_bloc.dart';

abstract class MovieWatchlistStatusEvent extends Equatable {
  const MovieWatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieWatchlistStatus extends MovieWatchlistStatusEvent {
  final int id;

  FetchMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends MovieWatchlistStatusEvent {
  final MovieDetail movie;

  AddWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class DeleteWatchlist extends MovieWatchlistStatusEvent {
  final MovieDetail movie;

  DeleteWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
