import 'dart:convert';

import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tResponseTvDetailModel = TvDetailResponse(
    adult: false,
    backdropPath: "backdrop_path",
    firstAirDate: "firstAirDate",
    genres: [],
    id: 1,
    lastAirDate: "lastAirDate",
    name: "name",
    numberOfEpisodes: 1,
    numberOfSeasons: 2,
    originalLanguage: "en",
    originalName: "name",
    overview: "overview",
    popularity: 4187.745,
    posterPath: "poster_path",
    seasons: [],
    status: "status",
    voteAverage: 8.607,
    voteCount: 1493,
  );

  group("fromJSON", () {
    test("should return a valid model from JSON", () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_dummy/tv_detail.json'));
      // act
      final result = TvDetailResponse.fromJSON(jsonMap);
      // assert
      expect(result, tResponseTvDetailModel);
    });
  });

  group("toJSON", () {
    test("should return a JSON map containing proper data", () async {
      // arrange

      // act
      final result = tResponseTvDetailModel.toJSON();
      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "backdrop_path",
        "first_air_date": "firstAirDate",
        "genres": [],
        "id": 1,
        "last_air_date": "lastAirDate",
        "name": "name",
        "number_of_episodes": 1,
        "number_of_seasons": 2,
        "original_language": "en",
        "original_name": "name",
        "overview": "overview",
        "popularity": 4187.745,
        "poster_path": "poster_path",
        "seasons": [],
        "status": "status",
        "vote_average": 8.607,
        "vote_count": 1493
      };

      expect(result, expectedJsonMap);
    });
  });
}
