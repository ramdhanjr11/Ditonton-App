import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_watchlist_status/tv_watchlist_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvWatchListStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late MockGetTvWatchListStatus mockGetTvWatchListStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;
  late TvWatchlistStatusBloc tvWatchlistStatusBloc;

  final tId = 1;

  setUp(() {
    mockGetTvWatchListStatus = MockGetTvWatchListStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    tvWatchlistStatusBloc = TvWatchlistStatusBloc(
      mockGetTvWatchListStatus,
      mockSaveTvWatchlist,
      mockRemoveTvWatchlist,
    );
  });

  blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
    'should emits [true] when fetch watchlist data is successfuly.',
    build: () {
      when(mockGetTvWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(FetchTvWatchlistStatus(tId)),
    expect: () => [
      TvWatchlistStatus(true, ''),
    ],
    verify: (bloc) {
      verify(mockGetTvWatchListStatus.execute(tId));
    },
  );

  blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
    'should emits [Loading, Status(true)] when add tv to watchlist is succesful.',
    build: () {
      when(mockSaveTvWatchlist.execute(testTvDetail)).thenAnswer(
          (_) async => Right(TvWatchlistStatusBloc.watchlistAddSuccessMessage));
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
    expect: () => [
      TvWatchlistStatusLoading(),
      TvWatchlistStatus(true, TvWatchlistStatusBloc.watchlistAddSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockSaveTvWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
    'should emits [Loading, Error] when add tv to watchlist is unsuccesful.',
    build: () {
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
    expect: () => [
      TvWatchlistStatusLoading(),
      TvWatchlistStatusError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveTvWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
    'should emits [Loading, Status(true)] when remove tv to watchlist is succesful.',
    build: () {
      when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer(
          (_) async => Right(TvWatchlistStatusBloc.watchlistAddSuccessMessage));
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(DeleteWatchlist(testTvDetail)),
    expect: () => [
      TvWatchlistStatusLoading(),
      TvWatchlistStatus(
          false, TvWatchlistStatusBloc.watchlistAddSuccessMessage),
    ],
    verify: (bloc) {
      verify(mockRemoveTvWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
    'should emits [Loading, Error] when add remove to watchlist is unsuccesful.',
    build: () {
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(DeleteWatchlist(testTvDetail)),
    expect: () => [
      TvWatchlistStatusLoading(),
      TvWatchlistStatusError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveTvWatchlist.execute(testTvDetail));
    },
  );
}
