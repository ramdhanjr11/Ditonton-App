import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_mocktail.dart';

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieWatchlistStatusBloc mockMovieWatchlistStatusBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;

  setUp(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    registerFallbackValue(FakeMovieWatchlistStatusEvent());
    registerFallbackValue(FakeMovieWatchlistStatusState());
    registerFallbackValue(FakeMovieRecommendationEvent());
    registerFallbackValue(FakeMovieRecommendationState());

    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieWatchlistStatusBloc = MockMovieWatchlistStatusBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => mockMovieDetailBloc,
        ),
        BlocProvider<MovieWatchlistStatusBloc>(
          create: (context) => mockMovieWatchlistStatusBloc,
        ),
        BlocProvider<MovieRecommendationBloc>(
          create: (context) => mockMovieRecommendationBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieWatchlistStatusBloc.state)
        .thenReturn(MovieWatchlistStatus(false, ''));
    when(() => mockMovieRecommendationBloc.state)
        .thenReturn(MovieRecommendationHasData(testMovieList));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => mockMovieWatchlistStatusBloc.state)
        .thenReturn(MovieWatchlistStatus(true, ''));
    when(() => mockMovieRecommendationBloc.state)
        .thenReturn(MovieRecommendationHasData(testMovieList));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    whenListen(
      mockMovieWatchlistStatusBloc,
      Stream.fromIterable(
        [
          MovieWatchlistStatus(false, ''),
          MovieWatchlistLoading(),
          MovieWatchlistStatus(
              true, MovieWatchlistStatusBloc.watchlistAddSuccessMessage)
        ],
      ),
      initialState: MovieWatchlistStatus(false, ''),
    );
    when(() => mockMovieRecommendationBloc.state)
        .thenReturn(MovieRecommendationHasData(testMovieList));

    expect(mockMovieWatchlistStatusBloc.state, MovieWatchlistStatus(false, ''));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
        mockMovieWatchlistStatusBloc.state,
        MovieWatchlistStatus(
            true, MovieWatchlistStatusBloc.watchlistAddSuccessMessage));
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    whenListen(
      mockMovieWatchlistStatusBloc,
      Stream.fromIterable(
        [
          MovieWatchlistStatus(false, ''),
          MovieWatchlistLoading(),
          MovieWatchlistError('Failed')
        ],
      ),
      initialState: MovieWatchlistStatus(false, ''),
    );
    when(() => mockMovieRecommendationBloc.state)
        .thenReturn(MovieRecommendationHasData(testMovieList));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
