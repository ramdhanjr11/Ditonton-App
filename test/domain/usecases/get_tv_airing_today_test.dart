import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_airing_today.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository repository;
  late GetTvAiringToday usecase;

  setUp(() {
    repository = MockMovieRepository();
    usecase = GetTvAiringToday(repository);
  });

  final tTvAiringTodays = <Tv>[];

  test('should get list of tv airing today when execute function is called',
      () async {
    // arrange
    when(repository.getTvAiringToday())
        .thenAnswer((_) async => Right(tTvAiringTodays));
    // act
    final result = await usecase.execute();
    // assert
    verify(repository.getTvAiringToday());
    expect(result, Right(tTvAiringTodays));
  });
}
