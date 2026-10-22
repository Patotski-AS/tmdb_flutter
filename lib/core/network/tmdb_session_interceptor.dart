import 'dart:async';

import 'package:dio/dio.dart';

/// [RequestOptions.extra] key that attaches the stored `session_id`.
///
/// The value must be `true`. Catalog, details and person requests
/// leave it unset. A missing session does not add an empty id.
const String attachTmdbSessionKey = 'attachTmdbSession';

/// Adds `session_id` when a request opts in and a session exists.
final class TmdbSessionInterceptor extends Interceptor {
  /// Creates an interceptor that reads the session per request.
  new({required this.readSessionId});

  /// Returns the stored `session_id`, or null when there is none.
  final Future<String?> Function() readSessionId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[attachTmdbSessionKey] != true) {
      handler.next(options);
      return;
    }
    unawaited(_attach(options, handler));
  }

  Future<void> _attach(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final sessionId = await readSessionId();
      if (sessionId != null && sessionId.trim().isNotEmpty) {
        options.queryParameters = {
          ...options.queryParameters,
          'session_id': sessionId,
        };
      }
      handler.next(options);
    } on Object catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
