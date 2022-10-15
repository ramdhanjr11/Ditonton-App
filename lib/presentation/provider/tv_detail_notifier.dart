import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/tv_detail.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
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
}
