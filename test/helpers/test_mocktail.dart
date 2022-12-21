import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:mocktail/mocktail.dart';

// mock movie detail bloc
class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

// mock movie watchlist status bloc
class MockMovieWatchlistStatusBloc
    extends MockBloc<MovieWatchlistStatusEvent, MovieWatchlistStatusState>
    implements MovieWatchlistStatusBloc {}

class FakeMovieWatchlistStatusEvent extends Fake
    implements MovieWatchlistStatusEvent {}

class FakeMovieWatchlistStatusState extends Fake
    implements MovieWatchlistStatusState {}

// mock movie recommendation bloc
class MockMovieRecommendationBloc
    extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

class FakeMovieRecommendationEvent extends Fake
    implements MovieRecommendationEvent {}

class FakeMovieRecommendationState extends Fake
    implements MovieRecommendationState {}
