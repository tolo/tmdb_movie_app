//library core;

import 'package:json_annotation/json_annotation.dart';
import 'tmdb_movie.dart';

part 'tmdb_movies_response.g.dart';

@JsonSerializable()
class TMDBMoviesResponse {
  final int page;
  final List<TMDBMovie> results;
  @JsonKey(name: 'total_results') final int totalResults;
  @JsonKey(name: 'total_pages') final int totalPages;
  @JsonKey(defaultValue: []) final List<String> errors;

  TMDBMoviesResponse({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
    required this.errors,
  });

  factory TMDBMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$TMDBMoviesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TMDBMoviesResponseToJson(this);
}

extension TMDBMoviesResponseX on TMDBMoviesResponse {
  //@late
  bool get isEmpty => !hasResults();

  bool hasResults() {
    return results.isNotEmpty;
  }

  bool hasErrors() {
    return errors.isNotEmpty;
  }
}
