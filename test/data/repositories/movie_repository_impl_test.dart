import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

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

  final tTv = Tv(
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

  final tTvModelList = [tTvModel];
  final tTvList = [tTv];

  final tTvDetail = TvDetail(
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

  final testTvDetail = TvDetail(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genres: [],
    id: 1,
    lastAirDate: 'lastAirDate',
    name: 'name',
    numberOfEpisodes: 1,
    numberOfSeasons: 2,
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    status: 'status',
    voteAverage: 1,
    voteCount: 2,
    seasons: [],
  );

  group('Now Playing Movies', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenAnswer((_) async => []);
      // act
      await repository.getNowPlayingMovies();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        verify(mockLocalDataSource.cacheNowPlayingMovies([testMovieCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingMovies())
            .thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingMovies())
            .thenAnswer((_) async => [testMovieCache]);
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingMovies());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testMovieFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingMovies())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingMovies());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularMovies())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getPopularMovies();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularMovies();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularMovies();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getTopRatedMovies();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedMovies();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedMovies();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Movie Detail', () {
    final tId = 1;
    final tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenAnswer((_) async => tMovieResponse);
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Right(testMovieDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Movies', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    group('movie', () {
      test('should return success message when saving successful', () async {
        // arrange
        when(mockLocalDataSource.insertWatchlist(testMovieTable))
            .thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveWatchlist(testMovieDetail);
        // assert
        expect(result, Right('Added to Watchlist'));
      });

      test('should return DatabaseFailure when saving unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.insertWatchlist(testMovieTable))
            .thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveWatchlist(testMovieDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to add watchlist')));
      });
    });

    group('tv', () {
      test('should return success message when saving successful', () async {
        // arrange
        when(mockLocalDataSource.insertTvWatchlist(testTvTable))
            .thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveTvWatchlist(testTvDetail);
        // assert
        expect(result, Right('Added to Watchlist'));
      });

      test('should return DatabaseFailure when saving unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.insertTvWatchlist(testTvTable))
            .thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveTvWatchlist(testTvDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to add watchlist')));
      });
    });
  });

  group('remove watchlist', () {
    group('movies', () {
      test('should return success message when remove successful', () async {
        // arrange
        when(mockLocalDataSource.removeWatchlist(testMovieTable))
            .thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeWatchlist(testMovieDetail);
        // assert
        expect(result, Right('Removed from watchlist'));
      });

      test('should return DatabaseFailure when remove unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.removeWatchlist(testMovieTable))
            .thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeWatchlist(testMovieDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
      });
    });

    group('tv', () {
      test('should return success message when remove successful', () async {
        // arrange
        when(mockLocalDataSource.removeTvWatchlist(testTvTable))
            .thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeTvWatchlist(testTvDetail);
        // assert
        expect(result, Right('Removed from watchlist'));
      });

      test('should return DatabaseFailure when remove unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.removeTvWatchlist(testTvTable))
            .thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeTvWatchlist(testTvDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
      });
    });
  });

  group('get watchlist status', () {
    group('movie', () {
      test('should return watch status whether data is found', () async {
        // arrange
        final tId = 1;
        when(mockLocalDataSource.getMovieById(tId))
            .thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedToWatchlist(tId);
        // assert
        expect(result, false);
      });
    });

    group('tv', () {
      test('should return watch status whether data is found', () async {
        // arrange
        final tId = 1;
        when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedToTvWatchlist(tId);
        // assert
        expect(result, false);
      });
    });
  });

  group('get watchlist movies', () {
    group('movie', () {
      test('should return list of Movies', () async {
        // arrange
        when(mockLocalDataSource.getWatchlistMovies())
            .thenAnswer((_) async => [testMovieTable]);
        // act
        final result = await repository.getWatchlistMovies();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testWatchlistMovie]);
      });
    });

    group('tv', () {
      test('should return list of tv', () async {
        // arrange
        when(mockLocalDataSource.getWatchlistTv())
            .thenAnswer((_) async => [testTvTable]);
        // act
        final result = await repository.getWatchlistTv();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testWatchlistTv]);
      });
    });
  });

  group('get popular tv', () {
    test('should return list of tv', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getPopularTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return ServerException when the call of remote data is unsuccessfull',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTv();
      // assert
      verify(mockRemoteDataSource.getPopularTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return SocketException when the call to remote data source is not connected to connection',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTv();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get tv detail', () {
    final tvId = 1;
    test('should return tv detail data', () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tvId)).thenAnswer((_) async =>
          TvDetailResponse.fromJSON(
              json.decode(readJson('dummy_data/tv_dummy/tv_detail.json'))));
      // act
      final result = await repository.getTvDetail(tvId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tvId));
      expect(result, equals(Right(tTvDetail)));
    });

    test(
        'should return ServerFailure when the call of remote data source is unsuccessfull',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tvId)).thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(tvId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tvId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should throw SocketException when the call to remote data source is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tvId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tvId);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get list of tv airing today', () {
    test(
        'should return list of tv airing today when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvAiringToday())
          .thenAnswer((_) async => tTvModelList);
      // act
      final call = await repository.getTvAiringToday();
      // assert
      verify(mockRemoteDataSource.getTvAiringToday());
      final result = call.getOrElse(() => []);
      expect(result, tTvList);
    });

    test(
        'should throw ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvAiringToday())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvAiringToday();
      // arrange
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should throw SocketException when the call of remote data source is not connected to network',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvAiringToday())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvAiringToday();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('get list of tv top rated', () {
    test(
        'should get list of tv top rated when the call of remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvTopRated())
          .thenAnswer((_) async => tTvModelList);
      // act
      final call = await repository.getTvTopRated();
      // assert
      verify(mockRemoteDataSource.getTvTopRated());
      final result = call.getOrElse(() => []);
      expect(result, tTvList);
    });

    test(
        'should throw ServerFailure when the call of remote data source is unsucessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvTopRated()).thenThrow(ServerException());
      // act
      final result = await repository.getTvTopRated();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should throw SocketException when the call of remote data source is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvTopRated())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvTopRated();
      // assert
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get tv recommendations', () {
    final tvId = 1;
    test(
        'should return list of tv recommendations when the call of remote data source is sucessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tvId))
          .thenAnswer((_) async => tTvModelList);
      // act
      final call = await repository.getTvRecommendations(tvId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tvId));
      final result = call.getOrElse(() => []);
      expect(result, tTvList);
    });

    test(
        'should throw ServerFailure when the call of remote data source is unsucessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tvId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tvId);
      // assert
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should throw SocketException when the call of remote data source is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tvId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvRecommendations(tvId);
      // assert
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('search tv', () {
    final tTvQuery = 'miracle';
    final tTvModelList = <TvModel>[];
    final tTvList = <Tv>[];
    test(
        'should return list of tv shows when the call of remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tTvQuery))
          .thenAnswer((_) async => tTvModelList);
      // act
      final call = await repository.searchTv(tTvQuery);
      // assert
      verify(mockRemoteDataSource.searchTv(tTvQuery));
      final result = call.getOrElse(() => []);
      expect(result, tTvList);
    });

    test(
        'should return ServerFailure when the call of remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tTvQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTv(tTvQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the call of remote data source is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tTvQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTv(tTvQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
}
