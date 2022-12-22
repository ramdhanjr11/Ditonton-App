import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late MockGetTvRecommendations mockGetTvRecommendations;
  late TvRecommendationBloc tvRecommendationBloc;

  final tId = 1;
  final tTv = Tv(
    backdropPath: "/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg",
    firstAirDate: "2022-08-21",
    genreIds: [10765, 18, 10759],
    id: 94997,
    name: "House of the Dragon",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "House of the Dragon",
    overview:
        "The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.",
    popularity: 7490.466,
    posterPath: "/17TTFFAXcg1hKAi1smsXsbpipru.jpg",
    voteAverage: 8.6,
    voteCount: 1437,
  );

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvRecommendationBloc = TvRecommendationBloc(mockGetTvRecommendations);
  });

  test('initiate state should be empty', () {
    expect(tvRecommendationBloc.state, TvRecommendationEmpty());
  });

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emits [Loading, Success] when data is gotten successfully.',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      TvRecommendationHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emits [Loading, Error] when getting data is an error.',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      TvRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(tId));
    },
  );
}
