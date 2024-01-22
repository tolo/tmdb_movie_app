//library core;

import 'package:json_annotation/json_annotation.dart';

part 'tmdb_movie.g.dart';

@JsonSerializable()
class TMDBMovie {
  final int id;
  final String title;
  @JsonKey(name: 'vote_count') final int? voteCount;
  @JsonKey(defaultValue: false) final bool video;
  @JsonKey(name: 'vote_average') final double? voteAverage;
  final double? popularity;
  @JsonKey(name: 'poster_path') final String? posterPath;
  @JsonKey(name: 'original_language') final String? originalLanguage;
  @JsonKey(name: 'original_title') final String? originalTitle;
  @JsonKey(name: 'genre_ids') final List<int>? genreIds;
  @JsonKey(name: 'backdrop_path') final String? backdropPath;
  final bool? adult;
  final String? overview;
  @JsonKey(name: 'release_date') final String? releaseDate;

  TMDBMovie({
    required this.id,
    required this.title,
    required this.voteCount,
    required this.video,
    required this.voteAverage,
    required this.popularity,
    required this.posterPath,
    required this.originalLanguage,
    required this.originalTitle,
    required this.genreIds,
    required this.backdropPath,
    required this.adult,
    required this.overview,
    required this.releaseDate,
  });

  factory TMDBMovie.fromJson(Map<String, Object?> json) => _$TMDBMovieFromJson(json);
  Map<String, dynamic> toJson() => _$TMDBMovieToJson(this);
}
