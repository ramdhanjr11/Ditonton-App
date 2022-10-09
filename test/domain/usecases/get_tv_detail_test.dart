import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockMovieRepository repository;

  setUp(() {
    repository = MockMovieRepository();
    usecase = GetTvDetail(repository);
  });

  final tvId = 1;

  test('should get tv detail data when execute is called', () async {
    // arrange
    when(repository.getTvDetail(tvId))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tvId);
    // assert
    expect(result, Right(testTvDetail));
  });
}
