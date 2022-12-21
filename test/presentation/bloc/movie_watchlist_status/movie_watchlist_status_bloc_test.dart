import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MovieWatchlistStatusBloc movieWatchlistStatusBloc;

  final tId = 1;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    movieWatchlistStatusBloc = MovieWatchlistStatusBloc(
        mockSaveWatchlist, mockRemoveWatchlist, mockGetWatchListStatus);
  });

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'should emits [true] when fetch watchlist data is successfuly.',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(FetchMovieWatchlistStatus(tId)),
    expect: () => [
      MovieWatchlistStatus(true, ''),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'should emits [Loading, Status(true)] when add movie to watchlist is succesful.',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async =>
          Right(MovieWatchlistStatusBloc.watchlistAddSuccessMessage));
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistStatus(
          true, MovieWatchlistStatusBloc.watchlistAddSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'should emits [Loading, Error] when add movie to watchlist is unsuccesful.',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'should emits [Loading, Status(true)] when remove movie to watchlist is succesful.',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async =>
          Right(MovieWatchlistStatusBloc.watchlistAddSuccessMessage));
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(DeleteWatchlist(testMovieDetail)),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistStatus(
          false, MovieWatchlistStatusBloc.watchlistAddSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'should emits [Loading, Error] when add movie to watchlist is unsuccesful.',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(DeleteWatchlist(testMovieDetail)),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );
}
