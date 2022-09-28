import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class TvModel extends Equatable {
  TvModel({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.originalLanguage,
  });

  final String backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final double voteAverage;
  final int voteCount;

  factory TvModel.fromJSON(Map<String, dynamic> json) => TvModel(
        backdropPath: json["backdrop_path"],
        firstAirDate: json["first_air_date"],
        genreIds: List<int>.from(json["genre_ids"].map((e) => e)),
        id: json["id"],
        name: json["name"],
        originCountry: List<String>.from(json["origin_country"].map((e) => e)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"],
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJSON() => {
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genre_ids": List<dynamic>.from(genreIds.map((e) => e)),
        "id": id,
        "name": name,
        "origin_country": List<dynamic>.from(originCountry.map((e) => e)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Tv toEntity() => Tv(
        backdropPath: backdropPath,
        firstAirDate: firstAirDate,
        genreIds: genreIds,
        id: id,
        name: name,
        originCountry: originCountry,
        originalLanguage: originalLanguage,
        originalName: originalName,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => [
        this.backdropPath,
        this.firstAirDate,
        this.genreIds,
        this.id,
        this.name,
        this.originCountry,
        this.originalLanguage,
        this.originalName,
        this.overview,
        this.popularity,
        this.posterPath,
        this.voteAverage,
        this.voteCount,
      ];
}
