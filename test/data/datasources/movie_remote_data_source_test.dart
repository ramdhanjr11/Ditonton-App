import 'dart:convert';

import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/now_playing.json')))
        .movieList;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/now_playing.json'), 200));
      // act
      final result = await dataSource.getNowPlayingMovies();
      // assert
      expect(result, equals(tMovieList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Movies', () {
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson('dummy_data/popular.json')))
            .movieList;

    test('should return list of movies when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular.json'), 200));
      // act
      final result = await dataSource.getPopularMovies();
      // assert
      expect(result, tMovieList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated.json')))
        .movieList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedMovies();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get movie detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/movie_detail.json'), 200));
      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getMovieDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get movie recommendations', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_recommendations.json')))
        .movieList;
    final tId = 1;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie_recommendations.json'), 200));
      // act
      final result = await dataSource.getMovieRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getMovieRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .movieList;
    final tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_movie.json'), 200));
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchMovies(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get popular tv', () {
    final tTvPopularResult = TvResponse.fromJSON(
            json.decode(readJson('dummy_data/tv_dummy/popular.json')))
        .listTvModel;

    test('should return list of tv popular when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_dummy/popular.json'), 200));
      // act
      final result = await dataSource.getPopularTv();
      // assert
      expect(result, tTvPopularResult);
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTv();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
  group('get tv detail', () {
    final tvId = 1;
    final tTvDetail = TvDetailResponse.fromJSON(
        json.decode(readJson('dummy_data/tv_dummy/tv_detail.json')));

    test('should return detail tv when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tvId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_dummy/tv_detail.json'), 200));
      // act
      final result = await dataSource.getTvDetail(tvId);
      // assert
      expect(result, tTvDetail);
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tvId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Server Error', 404));
      // act
      final call = dataSource.getTvDetail(tvId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Airing Today', () {
    final tTvAiringToday = TvResponse.fromJSON(
            json.decode(readJson('dummy_data/tv_dummy/airing_today.json')))
        .listTvModel;
    test('should return tv airing today data when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_dummy/airing_today.json'), 200));
      // act
      final result = await dataSource.getTvAiringToday();
      // assert
      expect(result, tTvAiringToday);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async => http.Response('Server Error', 404));
      // act
      final call = dataSource.getTvAiringToday();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv top rated', () {
    final tTvTopRated = TvResponse.fromJSON(
            json.decode(readJson('dummy_data/tv_dummy/top_rated.json')))
        .listTvModel;
    test('should return list of tv top rated when response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_dummy/top_rated.json'), 200));
      // act
      final result = await dataSource.getTvTopRated();
      // assert
      expect(result, tTvTopRated);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Server Error', 404));
      // act
      final result = dataSource.getTvTopRated();
      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tvId = 1;
    final tTvRecommendations = TvResponse.fromJSON(
            json.decode(readJson('dummy_data/tv_dummy/recommendations.json')))
        .listTvModel;
    test('should return list of tv recommendation when response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tvId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_dummy/recommendations.json'), 200));
      // act
      final result = await dataSource.getTvRecommendations(tvId);
      // assert
      expect(result, tTvRecommendations);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tvId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Server Error', 404));
      // act
      final result = dataSource.getTvRecommendations(tvId);
      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('search tv shows', () {
    final tTvShowSearch = TvResponse.fromJSON(
            json.decode(readJson('dummy_data/tv_dummy/search_miracle.json')))
        .listTvModel;
    final searchQuery = 'miracle';
    test('should return list of tv shows when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$searchQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_dummy/search_miracle.json'), 200));
      // act
      final result = await dataSource.searchTv(searchQuery);
      // assert
      expect(result, tTvShowSearch);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$searchQuery')))
          .thenThrow(ServerException());
      // act
      final result = dataSource.searchTv(searchQuery);
      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });
}
