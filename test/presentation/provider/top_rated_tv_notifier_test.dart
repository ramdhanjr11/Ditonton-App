import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetTvTopRated])
void main() {
  late MockGetTvTopRated mockGetTvTopRated;
  late TopRatedTvNotifier provider;
  late int listenerCount;

  setUp(() {
    listenerCount = 0;
    mockGetTvTopRated = MockGetTvTopRated();
    provider = TopRatedTvNotifier(getTvTopRated: mockGetTvTopRated)
      ..addListener(() {
        listenerCount += 1;
      });
  });

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
  final tTvList = [tTv];

  test('initialState should be empty', () async {
    expect(provider.state, RequestState.Empty);
  });

  test('should get data from usecase', () async {
    // arrange
    when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    provider.fetchTopRatedTv();
    // assert
    verify(mockGetTvTopRated.execute());
  });

  test('should change state to loading when get data is successfully',
      () async {
    // arrange
    when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    provider.fetchTopRatedTv();
    // assert
    expect(provider.state, RequestState.Loading);
    expect(listenerCount, 1);
  });

  test('should change tv data when get data is successfully', () async {
    // arrange
    when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    await provider.fetchTopRatedTv();
    // assert
    expect(provider.state, RequestState.Loaded);
    expect(provider.result, tTvList);
    expect(listenerCount, 2);
  });

  test('should change state to error when getting data is unsuccessfull',
      () async {
    // arrange
    when(mockGetTvTopRated.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchTopRatedTv();
    // assert
    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
