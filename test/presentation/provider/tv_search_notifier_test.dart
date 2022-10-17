import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([
  SearchTv,
])
void main() {
  late TvSearchNotifier provider;
  late SearchTv searchTvUsecase;
  late int listenerCount;

  setUp(() {
    listenerCount = 0;
    searchTvUsecase = MockSearchTv();
    provider = TvSearchNotifier(usecase: searchTvUsecase)
      ..addListener(() {
        listenerCount += 1;
      });
  });

  final tSearchQuery = "House of the Dragon";
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

  test('initialState should empty', () async {
    expect(provider.searchTvState, RequestState.Empty);
  });

  test('should get data from the usecase', () async {
    // arrange
    when(searchTvUsecase.execute(tSearchQuery))
        .thenAnswer((_) async => Right(tTvList));
    // act
    provider.searchTv(tSearchQuery);
    // assert
    verify(searchTvUsecase.execute(tSearchQuery));
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(searchTvUsecase.execute(tSearchQuery))
        .thenAnswer((_) async => Right(tTvList));
    // act
    provider.searchTv(tSearchQuery);
    // assert
    expect(provider.searchTvState, RequestState.Loading);
    expect(listenerCount, 1);
  });

  test('should change result data when fetch data is successfully', () async {
    // arrange
    when(searchTvUsecase.execute(tSearchQuery))
        .thenAnswer((_) async => Right(tTvList));
    // act
    await provider.searchTv(tSearchQuery);
    // assert
    expect(provider.searchTvState, RequestState.Loaded);
    expect(provider.result, tTvList);
    expect(listenerCount, 2);
  });

  test('should return error when fetch data is unsucessfully', () async {
    // arrange
    when(searchTvUsecase.execute(tSearchQuery))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await provider.searchTv(tSearchQuery);
    // assert
    expect(provider.searchTvState, RequestState.Error);
    expect(provider.message, 'Server Failure');
    expect(listenerCount, 2);
  });
}
