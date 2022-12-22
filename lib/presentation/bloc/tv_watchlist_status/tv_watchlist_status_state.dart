part of 'tv_watchlist_status_bloc.dart';

abstract class TvWatchlistStatusState extends Equatable {
  const TvWatchlistStatusState();

  @override
  List<Object> get props => [];
}

class TvWatchlistStatusLoading extends TvWatchlistStatusState {}

class TvWatchlistStatusError extends TvWatchlistStatusState {
  final String message;

  TvWatchlistStatusError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistStatus extends TvWatchlistStatusState {
  final bool status;
  final String message;

  TvWatchlistStatus(this.status, this.message);

  @override
  List<Object> get props => [status, message];
}
