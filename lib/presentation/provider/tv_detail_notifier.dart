import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/tv_detail.dart';
import '../../domain/usecases/get_tv_watchlist_status.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvWatchListStatus getWatchListStatus;
  final SaveTvWatchlist saveWatchlist;
  final RemoveTvWatchlist removeWatchlist;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  var _tvDetailState = RequestState.Empty;
  RequestState get tvDetailState => _tvDetailState;

  late TvDetail _tvDetail;
  TvDetail get tvDetail => _tvDetail;

  var _tvRecommendationState = RequestState.Empty;
  RequestState get tvRecommendationState => _tvRecommendationState;

  late List<Tv> _tvRecommendations;
  List<Tv> get tvRecommendations => _tvRecommendations;

  String _message = "";
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvDetailState = RequestState.Loading;
    notifyListeners();

    final tvDetailresult = await getTvDetail.execute(id);
    final tvRecommendationsResult = await getTvRecommendations.execute(id);

    tvDetailresult.fold(
      (error) {
        _message = error.message;
        _tvDetailState = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tvRecommendationState = RequestState.Loading;
        _tvDetail = tvData;
        notifyListeners();
        tvRecommendationsResult.fold(
          (failure) {
            _tvRecommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvRecommendations) {
            _tvRecommendationState = RequestState.Loaded;
            _tvRecommendations = tvRecommendations;
          },
        );
        _tvDetailState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
