import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetTvWatchListStatus {
  final MovieRepository repository;

  GetTvWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToTvWatchlist(id);
  }
}
