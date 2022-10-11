import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository repository;
  late SearchTv usecase;

  setUp(() {
    repository = MockMovieRepository();
    usecase = SearchTv(repository);
  });

  final tQuery = "miracle";
  final tTvList = <Tv>[];

  test('should get list of tv from searcher when execute function is called',
      () async {
    // arrange
    when(repository.searchTv(tQuery)).thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    verify(repository.searchTv(tQuery));
    expect(result, Right(tTvList));
  });
}
