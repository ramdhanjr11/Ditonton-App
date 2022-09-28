import 'package:ditonton/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  final List<TvModel> listTvModel;

  TvResponse({required this.listTvModel});

  factory TvResponse.fromJSON(Map<String, dynamic> json) => TvResponse(
      listTvModel:
          (json["results"] as List).map((e) => TvModel.fromJSON(e)).toList());

  Map<String, dynamic> toJSON() =>
      {"results": List<dynamic>.from(listTvModel.map((e) => e.toJSON()))};

  @override
  List<Object?> get props => [this.listTvModel];
}
