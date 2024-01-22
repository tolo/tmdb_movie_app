import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_result_notifier/src/features/movies/data/movies_repository.dart';

import 'package:tmdb_movie_app_result_notifier/src/routing/app_router.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/dio_provider.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/service_provider.dart';

Future<void> main() async {
  runApp(SimpleServiceProvider(
    services: {
      MoviesService: moviesServiceProvider,
      GoRouter: goRouterProvider,
      Dio: dioProvider,
    },
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = context.service();
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
