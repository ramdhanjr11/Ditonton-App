import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:flutter/widgets.dart';

class TvSearchNotifier extends ChangeNotifier {
  final SearchTv usecase;

  TvSearchNotifier({required this.usecase});

  var _result = <Tv>[];
  List<Tv> get result => _result;

  RequestState _searchTvState = RequestState.Empty;
  RequestState get searchTvState => _searchTvState;

  String _message = "";
  String get message => _message;

  Future<void> fetchTvSearch(String query) async {
    _searchTvState = RequestState.Loading;
    notifyListeners();

    final result = await usecase.execute(query);
    result.fold(
      (failure) {
        _searchTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _searchTvState = RequestState.Loaded;
        _result = tvData;
        notifyListeners();
      },
    );
  }
}
