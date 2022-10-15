import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_airing_today.dart';
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

  var _tvAiringToday = <Tv>[];
  List<Tv> get tvAiringToday => _tvAiringToday;

  RequestState _tvAiringTodayState = RequestState.Empty;
  RequestState get tvAiringTodayState => _tvAiringTodayState;

  TvListNotifier(
      {required this.getPopularTv,
      required this.getTvTopRated,
      required this.getTvAiringToday});

  String _message = "";
  String get message => _message;

  final GetPopularTv getPopularTv;
  final GetTvTopRated getTvTopRated;
  final GetTvAiringToday getTvAiringToday;

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

  Future<void> fetchTvAiringToday() async {
    _tvAiringTodayState = RequestState.Loading;
    notifyListeners();

    final result = await getTvAiringToday.execute();
    result.fold((failure) {
      _tvAiringTodayState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvData) {
      _tvAiringTodayState = RequestState.Loaded;
      _tvAiringToday = tvData;
      notifyListeners();
    });
  }
}
