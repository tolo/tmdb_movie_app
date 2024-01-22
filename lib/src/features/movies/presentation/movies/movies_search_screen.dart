import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:result_notifier/result_notifier.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/data/movies_pagination.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/data/movies_repository.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/presentation/movies/movie_list_tile.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/presentation/movies/movie_list_tile_shimmer.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/presentation/movies/movies_search_bar.dart';
import 'package:tmdb_movie_app_result_notifier/src/routing/app_router.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/service_provider.dart';

class MoviesSearchScreen extends ResourceProvider<ValueNotifier<String>> {
  const MoviesSearchScreen({super.key});

  @override
  ValueNotifier<String> createResource(BuildContext context) => ValueNotifier('');

  @override
  Widget build(BuildContext context, ValueNotifier<String> resource) {
    return ListenableBuilder(listenable: resource, builder: (context, _)
      => buildWithQuery(context, resource));
  }

  Widget buildWithQuery(BuildContext context, ValueNotifier<String> query) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB Movies'),
      ),
      body: Column(
        children: [
          MoviesSearchBar(query: query),
          Expanded(
            child: MovieList(query: query.value),
          ),
        ],
      ),
    );
  }
}

class MovieList extends ResourceProvider<MovieListCache> {
  MovieList({required this.query}) : super(key: ValueKey('MovieListQuery:$query'));

  static const pageSize = 20;

  final String query;

  @override MovieListCache createResource(BuildContext context) {
    return context.service<MoviesService>().moviesListCache();
  }

  @override void disposeResource(BuildContext context, MovieListCache resource) {
    resource.dispose();
  }

  @override
  Widget build(BuildContext context, MovieListCache resource) {
    return ListenableBuilder(
      listenable: resource,
      builder: (context, _) => _movieList(context, resource),
    );
  }

  Widget _movieList(BuildContext context, MovieListCache moviesListCache) {
    return RefreshIndicator(
      onRefresh: () {
        // dispose all the pages previously fetched. Next read will refresh them
        moviesListCache.invalidateAll();
        // keep showing the progress indicator until the first page is fetched
        return moviesListCache.refreshAwait(MoviesPagination(page: 1, query: query));
      },
      // TODO: Limit item count to pagination results
      child: ListView.custom(
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          final page = index ~/ pageSize + 1;
          final indexInPage = index % pageSize;
          // use the fact that this is an infinite list to fetch a new page
          // as soon as the index exceeds the page size
          // Note that ref.watch is called for up to pageSize items
          // with the same page and query arguments (but this is ok since data is cached)
          final moviesList = moviesListCache.value(MoviesPagination(page: page, query: query));
          return moviesList.when(
            // TODO: Improve error handling
            error: (err, stack, movies) => Text('Error $err'),
            loading: (_) => const MovieListTileShimmer(),
            data: (movies) {
              if (indexInPage >= movies.length) {
                return const MovieListTileShimmer();
              }
              final movie = movies[indexInPage];
              return MovieListTile(
                movie: movie,
                debugIndex: index,
                onPressed: () => context.goNamed(
                  AppRoute.movie.name,
                  pathParameters: {'id': movie.id.toString()},
                  extra: movie,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
