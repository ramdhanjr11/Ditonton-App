import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_airing_today.dart';
import 'package:ditonton/presentation/bloc/tv_airing_today/tv_airing_today_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_airing_today_bloc_test.mocks.dart';

@GenerateMocks([GetTvAiringToday])
void main() {
  late MockGetTvAiringToday mockGetTvAiringToday;
  late TvAiringTodayBloc tvAiringTodayBloc;

  setUp(() {
    mockGetTvAiringToday = MockGetTvAiringToday();
    tvAiringTodayBloc = TvAiringTodayBloc(mockGetTvAiringToday);
  });

  test('initiate state should be empty', () {
    expect(tvAiringTodayBloc.state, TvAiringTodayEmpty());
  });

  blocTest<TvAiringTodayBloc, TvAiringTodayState>(
    'should emits [Loading, Success] when data is gotten successfully.',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(testTvList));
      return tvAiringTodayBloc;
    },
    act: (bloc) => bloc.add(FetchTvAiringToday()),
    expect: () => [
      TvAiringTodayLoading(),
      TvAiringTodayHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTvAiringToday.execute());
    },
  );

  blocTest<TvAiringTodayBloc, TvAiringTodayState>(
    'should emits [Loading, Error] when getting data is an error.',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvAiringTodayBloc;
    },
    act: (bloc) => bloc.add(FetchTvAiringToday()),
    expect: () => [
      TvAiringTodayLoading(),
      TvAiringTodayError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvAiringToday.execute());
    },
  );
}
