import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

import '../entities/tv.dart';

class GetPopularTv {
  final MovieRepository movieRepository;

  GetPopularTv(this.movieRepository);

  Future<Either<Failure, List<Tv>>> execute() async {
    return movieRepository.getPopularTv();
  }
}
