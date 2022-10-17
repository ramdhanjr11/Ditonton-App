import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_airing_today.dart';
import 'package:flutter/widgets.dart';

class AiringTodayTvNotifier extends ChangeNotifier {
  final GetTvAiringToday getTvAiringToday;

  AiringTodayTvNotifier({required this.getTvAiringToday});

  var _result = <Tv>[];
  List<Tv> get result => _result;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvAiringToday() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTvAiringToday.execute();
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
