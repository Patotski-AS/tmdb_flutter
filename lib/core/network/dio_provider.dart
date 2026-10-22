import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_config.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';
import 'package:tmdb_flutter/core/network/tmdb_session_interceptor.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';

part 'dio_provider.g.dart';

/// Dio client for `https://api.themoviedb.org/3/`.
///
/// Sends `Authorization: Bearer <TMDB_ACCESS_TOKEN>`.
/// Adds `session_id` only when [attachTmdbSessionKey] is true
/// and a session is stored. Logging runs only in debug builds.
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
  client.interceptors.add(
    TmdbSessionInterceptor(
      readSessionId: () =>
          ref.read(sessionRepositoryProvider.notifier).getSessionId(),
    ),
  );
  if (kDebugMode) {
    client.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
  ref.onDispose(client.close);
  return client;
}
