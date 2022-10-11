import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository repository;
  late GetTvTopRated usecase;

  setUp(() {
    repository = MockMovieRepository();
    usecase = GetTvTopRated(repository);
  });

  final tTvTopRated = <Tv>[];
  test('should return list of tv top rated when execute function is called',
      () async {
    // arrange
    when(repository.getTvTopRated())
        .thenAnswer((_) async => Right(tTvTopRated));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvTopRated));
  });
}
