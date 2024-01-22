import 'dart:async';

import 'package:dio/dio.dart';
import 'package:result_notifier/result_notifier.dart';
import 'package:tmdb_movie_app_result_notifier/env/env.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/data/movies_pagination.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/domain/tmdb_movie.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/domain/tmdb_movies_response.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/cancellable_notifier.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/service_provider.dart';


class MoviesRepository {
  MoviesRepository({required this.client, required this.apiKey});
  final Dio client;
  final String apiKey;

  Future<List<TMDBMovie>> searchMovies(
      {required int page, String query = '', CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/search/movie',
      queryParameters: {
        'api_key': apiKey,
        'include_adult': 'false',
        'page': '$page',
        'query': query,
      },
    ).toString();
    final response = await client.get(url, cancelToken: cancelToken);
    final movies = TMDBMoviesResponse.fromJson(response.data);
    return movies.results;
  }

  Future<List<TMDBMovie>> nowPlayingMovies(
      {required int page, CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/movie/now_playing',
      queryParameters: {
        'api_key': apiKey,
        'include_adult': 'false',
        'page': '$page',
      },
    ).toString();
    final response = await client.get(url, cancelToken: cancelToken);
    final movies = TMDBMoviesResponse.fromJson(response.data);
    return movies.results;
  }

  Future<TMDBMovie> movie(
      {required int movieId, CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/movie/$movieId',
      queryParameters: {
        'api_key': apiKey,
        'include_adult': 'false',
      },
    ).toString();
    final response = await client.get(url, cancelToken: cancelToken);
    return TMDBMovie.fromJson(response.data);
  }
}

typedef MovieListCache = ResultStore<MoviesPagination, List<TMDBMovie>>;

final moviesServiceProvider = SingletonService.provide(
  (serviceLocator) => MoviesService(MoviesRepository(
    client: serviceLocator.get<Dio>(),
    apiKey: Env.tmdbApiKey,
  )),
);

class MoviesService {
  MoviesService(this.repository);

  final MoviesRepository repository;

  FutureNotifier<TMDBMovie> movieDetails(int movieId) {
    return CancellableNotifier<TMDBMovie>(
      id: 'movieDetails ($movieId)',
      fetch: (cancelToken) => repository.movie(
        movieId: movieId,
        cancelToken: cancelToken,
      ),
    );
  }

  MovieListCache moviesListCache() {
    return ResultStore<MoviesPagination, List<TMDBMovie>>(
      autoDispose: true,
      create: (pagination, store) =>
        CancellableNotifier(
          id: pagination.toString(),
          fetch: (cancelToken) => _fetchMovies(pagination, cancelToken),
          expiration: const Duration(seconds: 30),
        ),
    );
  }

  Future<List<TMDBMovie>> _fetchMovies(MoviesPagination pagination, CancelToken cancelToken) async {
    if (pagination.query.isEmpty) {
      // use non-search endpoint
      return repository.nowPlayingMovies(
        page: pagination.page,
        cancelToken: cancelToken,
      );
    } else {
      // Debounce the request. By having this delay, consumers can subscribe to
      // different parameters. In which case, this request will be aborted.
      await Future.delayed(const Duration(milliseconds: 500));
      if (cancelToken.isCancelled) throw CancelledException();
      // use search endpoint
      return repository.searchMovies(
        page: pagination.page,
        query: pagination.query,
        cancelToken: cancelToken,
      );
    }
  }
}
