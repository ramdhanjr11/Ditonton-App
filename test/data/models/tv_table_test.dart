import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTv = Tv.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTvTableMap = {
    'id': 1,
    'name': 'name',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  final tTvModel = TvModel(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalName: 'originalName',
    overview: 'overview',
    popularity: 3.5,
    posterPath: 'posterPath',
    voteAverage: 4,
    voteCount: 4,
    originalLanguage: 'originalLanguage',
  );

  test('should be sub class of entity', () async {
    final result = testTvTable.toEntity();
    expect(result, tTv);
  });

  test('should be sub class of table when converting from map sub class',
      () async {
    final result = TvTable.fromMap(tTvTableMap);
    expect(result, testTvTable);
  });

  test('should be sub class of table when converting from DTO', () async {
    final result = TvTable.fromDTO(tTvModel);
    expect(result, testTvTable);
  });

  test('should be to map from table', () async {
    final result = testTvTable.toJson();
    expect(result, tTvTableMap);
  });

  test('should be to entity from table', () async {
    final result = testTvTable.toEntity();
    expect(result, tTv);
  });
}
