import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: "/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg",
    firstAirDate: "2022-08-21",
    genreIds: [10765, 18, 10759],
    id: 94997,
    name: "House of the Dragon",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "House of the Dragon",
    overview:
        "The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.",
    popularity: 7490.466,
    posterPath: "/17TTFFAXcg1hKAi1smsXsbpipru.jpg",
    voteAverage: 8.6,
    voteCount: 1437,
  );

  final tResponseTvModel = TvResponse(listTvModel: [tTvModel]);

  group("fromJSON", () {
    test("should return a valid model from JSON", () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson("dummy_data/tv_dummy/popular.json"));
      // act
      final result = TvResponse.fromJSON(jsonMap);
      // assert
      expect(result, tResponseTvModel);
    });
  });

  group("toJSON", () {
    test("should return a JSON map containing proper data", () async {
      // arrange

      // act
      final result = tResponseTvModel.toJSON();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg",
            "first_air_date": "2022-08-21",
            "genre_ids": [10765, 18, 10759],
            "id": 94997,
            "name": "House of the Dragon",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "House of the Dragon",
            "overview":
                "The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.",
            "popularity": 7490.466,
            "poster_path": "/17TTFFAXcg1hKAi1smsXsbpipru.jpg",
            "vote_average": 8.6,
            "vote_count": 1437
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
