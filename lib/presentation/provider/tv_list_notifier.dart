import 'dart:developer';

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter/widgets.dart';

class TvListNotifier extends ChangeNotifier {
  var _popularTv = <Tv>[];
  List<Tv> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  TvListNotifier({required this.getPopularTv});

  String _message = "";
  String get message => _message;

  final GetPopularTv getPopularTv;

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    log('testing: masuk');
    final result = await getPopularTv.execute();
    result.fold((failure) {
      _popularTvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
      log('testing: gagal');
    }, (tvData) {
      _popularTvState = RequestState.Loaded;
      _popularTv = tvData;
      notifyListeners();
      log('testing: berhasil');
    });
  }
}
