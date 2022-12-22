import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_airing_today/tv_airing_today_bloc.dart';
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

// mock popular movie bloc
class MockPopularMovieBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class FakePopularMovieEvent extends Fake implements PopularMoviesEvent {}

class FakePopularMovieState extends Fake implements PopularMoviesState {}

// mock top rated movies bloc
class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

// mock popular tv bloc
class MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class FakePopularTvEvent extends Fake implements PopularTvEvent {}

class FakePopularTvState extends Fake implements PopularTvState {}

// mock top rated tv bloc
class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

// mock tv airing today bloc
class MockTvAiringTodayBloc
    extends MockBloc<TvAiringTodayEvent, TvAiringTodayState>
    implements TvAiringTodayBloc {}

class FakeTvAiringTodayEvent extends Fake implements TvAiringTodayEvent {}

class FakeTvAiringTodayState extends Fake implements TvAiringTodayState {}
