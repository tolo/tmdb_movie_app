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
      return ResourceProvider(
        create: (context) => context.service<MoviesService>().movieDetails(movieId),
        builder: (context, notifier) => _LoadMovieDetails(movie: notifier),
      );
    }
  }
}

class _LoadMovieDetails extends WatcherWidget {
  const _LoadMovieDetails({required this.movie});

  final ResultNotifier<TMDBMovie> movie;

  @override
  Widget build(WatcherContext context) =>
      switch(movie.watch(context)) {
        (Error result) => Scaffold(
          appBar: AppBar(
            title: Text(result.data?.title ?? 'Error'),
          ),
          body: Center(child: Text(result.error.toString())),
        ),
        (Loading result) => Scaffold(
          appBar: AppBar(
            title: Text(result.data?.title ?? 'Loading'),
          ),
          body: const Column(
            children: [
              MovieListTileShimmer(),
            ],
          ),
        ),
        (Data result) => Scaffold(
          appBar: AppBar(
            title: Text(result.data.title),
          ),
          body: Column(
            children: [
              MovieListTile(movie: result.data),
            ],
          ),
        ),
      };
}
