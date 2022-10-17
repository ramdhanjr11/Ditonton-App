import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated.dart';
import 'package:flutter/widgets.dart';

import '../../common/state_enum.dart';

class TopRatedTvNotifier extends ChangeNotifier {
  final GetTvTopRated getTvTopRated;

  TopRatedTvNotifier({required this.getTvTopRated});

  var _result = <Tv>[];
  List<Tv> get result => _result;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTvTopRated.execute();
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _state = RequestState.Loaded;
        _result = tvData;
        notifyListeners();
      },
    );
  }
}
