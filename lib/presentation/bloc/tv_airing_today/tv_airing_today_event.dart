part of 'tv_airing_today_bloc.dart';

abstract class TvAiringTodayEvent extends Equatable {
  const TvAiringTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchTvAiringToday extends TvAiringTodayEvent {}
