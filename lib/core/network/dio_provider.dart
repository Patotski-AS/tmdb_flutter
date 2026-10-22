import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_config.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';

part 'dio_provider.g.dart';

/// Dio client for `https://api.themoviedb.org/3/`.
///
/// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
/// Logging is attached only in debug builds.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final token = requireTmdbAccessToken();
  final client = Dio(
    BaseOptions(
      baseUrl: tmdbBaseUrl,
      connectTimeout: tmdbConnectTimeout,
      receiveTimeout: tmdbReceiveTimeout,
      headers: {'Authorization': 'Bearer $token'},
    ),
  );
  client.interceptors.add(const TmdbExceptionInterceptor());
  if (kDebugMode) {
    client.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
  ref.onDispose(client.close);
  return client;
}
