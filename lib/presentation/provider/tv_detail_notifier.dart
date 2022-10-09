import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/tv_detail.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;

  TvDetailNotifier({required this.getTvDetail});

  var _tvDetailState = RequestState.Empty;
  RequestState get tvDetailState => _tvDetailState;

  late TvDetail _tvDetail;
  TvDetail get tvDetail => _tvDetail;

  String _message = "";
  String get message => _message;

  Future<void> fetchTvDetail(int id) async {
    _tvDetailState = RequestState.Loading;
    notifyListeners();

    final result = await getTvDetail.execute(id);
    result.fold((error) {
      _message = error.message;
      _tvDetailState = RequestState.Error;
      notifyListeners();
    }, (tvData) {
      _tvDetail = tvData;
      _tvDetailState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
