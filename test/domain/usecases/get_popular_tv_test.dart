import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetPopularTv(movieRepository: mockMovieRepository);
  });

  final tTv = <Tv>[];

  group('GetPopularTv Test', () {
    test('should return list of tv when execute function is called', () async {
      // arrange
      when(mockMovieRepository.getPopularTv())
          .thenAnswer((_) async => Right(tTv));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTv));
    });
  });
}
