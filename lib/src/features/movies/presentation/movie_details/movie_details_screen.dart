import 'package:flutter/material.dart';

import 'package:result_notifier/result_notifier.dart';

import 'package:tmdb_movie_app_result_notifier/src/features/movies/data/movies_repository.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/domain/tmdb_movie.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/presentation/movies/movie_list_tile.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/presentation/movies/movie_list_tile_shimmer.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/service_provider.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen(
      {super.key, required this.movieId, required this.movie});
  final int movieId;
  final TMDBMovie? movie;

  @override
  Widget build(BuildContext context) {
    if (movie != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(movie!.title),
        ),
        body: Column(
          children: [
            MovieListTile(movie: movie!),
          ],
        ),
      );
    } else {
      return _LoadMovieDetails(movieId: movieId);
    }
  }
}

class _LoadMovieDetails extends ResultNotifierProvider<TMDBMovie> {
  const _LoadMovieDetails({required this.movieId});
  final int movieId;

  @override
  ResultNotifier<TMDBMovie> createResource(BuildContext context) {
    return context.service<MoviesService>().movieDetails(movieId);
  }

  @override
  Widget buildResult(BuildContext context, ResultNotifier<TMDBMovie> notifier, Result<TMDBMovie> result) {
    return result.when(
      error: (e, st, movie) => Scaffold(
        appBar: AppBar(
          title: Text(movie?.title ?? 'Error'),
        ),
        body: Center(child: Text(e.toString())),
      ),
      loading: (movie) => Scaffold(
        appBar: AppBar(
          title: Text(movie?.title ?? 'Loading'),
        ),
        body: const Column(
          children: [
            MovieListTileShimmer(),
          ],
        ),
      ),
      data: (movie) => Scaffold(
        appBar: AppBar(
          title: Text(movie.title),
        ),
        body: Column(
          children: [
            MovieListTile(movie: movie),
          ],
        ),
      ),
    );
  }
}
