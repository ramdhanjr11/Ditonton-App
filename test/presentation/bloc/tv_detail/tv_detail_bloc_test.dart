import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc tvDetailBloc;

  final tId = 1;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(mockGetTvDetail);
  });

  test('initiate state should be empty', () {
    expect(tvDetailBloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'should emits [Loading, Success] when data is gotten successfully.',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(testTvDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'should emits [Loading, Error] when getting data is an error.',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );
}
