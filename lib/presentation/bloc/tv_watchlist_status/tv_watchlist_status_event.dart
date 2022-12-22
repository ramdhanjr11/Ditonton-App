part of 'tv_watchlist_status_bloc.dart';

abstract class TvWatchlistStatusEvent extends Equatable {
  const TvWatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class FetchTvWatchlistStatus extends TvWatchlistStatusEvent {
  final int id;

  FetchTvWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends TvWatchlistStatusEvent {
  final TvDetail tv;

  AddWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class DeleteWatchlist extends TvWatchlistStatusEvent {
  final TvDetail tv;

  DeleteWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
