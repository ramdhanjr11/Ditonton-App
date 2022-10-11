import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

import '../../common/failure.dart';

class GetTvTopRated {
  final MovieRepository repository;

  GetTvTopRated(this.repository);

  Future<Either<Failure, List<Tv>>> execute() async {
    return repository.getTvTopRated();
  }
}
