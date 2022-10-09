import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetTvDetail {
  final MovieRepository movieRepository;

  GetTvDetail(this.movieRepository);

  Future<Either<Failure, TvDetail>> execute(int tvId) {
    return movieRepository.getTvDetail(tvId);
  }
}
