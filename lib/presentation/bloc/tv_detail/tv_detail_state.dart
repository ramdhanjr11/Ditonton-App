part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailHasData extends TvDetailState {
  final TvDetail result;

  TvDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}
