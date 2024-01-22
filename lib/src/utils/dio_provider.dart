import 'package:dio/dio.dart';

import 'package:tmdb_movie_app_result_notifier/src/utils/logger_interceptor.dart';
import 'package:tmdb_movie_app_result_notifier/src/utils/service_provider.dart';

final dioProvider = SingletonService.provide((locator) {
  final dio = Dio();
  dio.interceptors.add(LoggerInterceptor());
  return dio;
});
