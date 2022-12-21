import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvTopRated])
void main() {
  late MockGetTvTopRated mockGetTvTopRated;
  late TopRatedTvBloc topRatedTvBloc;

  setUp(() {
    mockGetTvTopRated = MockGetTvTopRated();
    topRatedTvBloc = TopRatedTvBloc(mockGetTvTopRated);
  });

  test('initiate state should be empty', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emits [Loading, Success] when data is gotten successfully.',
    build: () {
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Right(testTvList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTvTopRated.execute());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emits [Loading, Error] when getting data is an error.',
    build: () {
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvTopRated.execute());
    },
  );
}
