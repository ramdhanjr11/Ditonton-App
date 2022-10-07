import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: "airdate",
    episodeCount: 3,
    id: 1,
    name: "season model",
    overview: "overview",
    posterPath: "poster path",
    seasonNumber: 8,
  );

  final tSeason = Season(
    airDate: "airdate",
    episodeCount: 3,
    id: 1,
    name: "season model",
    overview: "overview",
    posterPath: "poster path",
    seasonNumber: 8,
  );

  test("should be a sub of season entity", () {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });
}
