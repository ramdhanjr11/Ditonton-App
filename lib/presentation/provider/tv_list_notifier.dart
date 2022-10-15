import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated.dart';
import 'package:flutter/widgets.dart';

class TvListNotifier extends ChangeNotifier {
  var _popularTv = <Tv>[];
  List<Tv> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  var _tvTopRated = <Tv>[];
  List<Tv> get tvTopRated => _tvTopRated;

  RequestState _tvTopRatedState = RequestState.Empty;
  RequestState get tvTopRatedState => _tvTopRatedState;

  TvListNotifier({required this.getPopularTv, required this.getTvTopRated});

  String _message = "";
  String get message => _message;

  final GetPopularTv getPopularTv;
  final GetTvTopRated getTvTopRated;

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold((failure) {
      _popularTvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvData) {
      _popularTvState = RequestState.Loaded;
      _popularTv = tvData;
      notifyListeners();
    });
  }

  Future<void> fetchTvTopRated() async {
    _tvTopRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTvTopRated.execute();
    result.fold((failure) {
      _tvTopRatedState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvData) {
      _tvTopRatedState = RequestState.Loaded;
      _tvTopRated = tvData;
      notifyListeners();
    });
  }
}
