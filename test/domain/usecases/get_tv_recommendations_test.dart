import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository repository;
  late GetTvRecommendations usecase;

  setUp(() {
    repository = MockMovieRepository();
    usecase = GetTvRecommendations(repository);
  });

  final tTvRecommendations = <Tv>[];
  final tId = 1;

  test('should get list of tv recommendations', () async {
    // arrange
    when(repository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvRecommendations));
    // act
    final result = await usecase.execute(tId);
    // assert
    verify(repository.getTvRecommendations(tId));
    expect(result, Right(tTvRecommendations));
  });
}
