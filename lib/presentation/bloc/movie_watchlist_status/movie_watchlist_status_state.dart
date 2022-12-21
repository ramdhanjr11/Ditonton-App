part of 'movie_watchlist_status_bloc.dart';

abstract class MovieWatchlistStatusState extends Equatable {
  const MovieWatchlistStatusState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistLoading extends MovieWatchlistStatusState {}

class MovieWatchlistError extends MovieWatchlistStatusState {
  final String message;

  MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistStatus extends MovieWatchlistStatusState {
  final bool status;
  final String message;

  MovieWatchlistStatus(this.status, this.message);

  @override
  List<Object> get props => [status, message];
}
