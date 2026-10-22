import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_error_body.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';

/// Turns a [DioException] into a [TmdbException].
TmdbException mapDioException(DioException exception) {
  final nested = exception.error;
  if (nested is TmdbException) {
    return nested;
  }

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return TmdbNetworkException(
        'Превышено время ожидания ответа TMDB.',
        cause: exception,
      );
    case DioExceptionType.badCertificate:
    case DioExceptionType.connectionError:
      return TmdbNetworkException(
        'Нет соединения с TMDB.',
        cause: exception,
      );
    case DioExceptionType.cancel:
      return TmdbNetworkException(
        'Запрос к TMDB отменён.',
        cause: exception,
      );
    case DioExceptionType.badResponse:
      return _exceptionFromResponse(exception);
    case DioExceptionType.unknown:
      if (exception.response == null) {
        return TmdbNetworkException(
          'Нет соединения с TMDB.',
          cause: exception,
        );
      }
      return _exceptionFromResponse(exception);
  }
}

/// Rewrites Dio failures so [DioException.error] is a [TmdbException].
class TmdbExceptionInterceptor extends Interceptor {
  /// Creates an interceptor that maps TMDB failures.
  const new();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.error is TmdbException) {
      handler.next(err);
      return;
    }
    final mapped = mapDioException(err);
    handler.reject(err.copyWith(error: mapped, message: mapped.message));
  }
}

TmdbException _exceptionFromResponse(DioException exception) {
  final response = exception.response;
  if (response == null) {
    return TmdbResponseException('Неверный ответ TMDB.', cause: exception);
  }

  final httpStatus = response.statusCode;
  final payload = response.data as Object?;
  if (payload == null) {
    return TmdbHttpException(
      statusCode: httpStatus ?? 0,
      statusMessage: _httpFallback(httpStatus),
      httpStatusCode: httpStatus,
    );
  }

  try {
    final json = _asJsonMap(payload);
    if (json == null) {
      return TmdbResponseException('Неверный ответ TMDB.', cause: exception);
    }
    final body = TmdbErrorBody.fromJson(json);
    final statusMessage = body.statusMessage?.trim();
    final message = (statusMessage == null || statusMessage.isEmpty)
        ? _httpFallback(httpStatus)
        : statusMessage;
    return TmdbHttpException(
      statusCode: body.statusCode ?? httpStatus ?? 0,
      statusMessage: message,
      httpStatusCode: httpStatus,
    );
  } on FormatException catch (error) {
    return TmdbResponseException('Неверный ответ TMDB.', cause: error);
  } on CheckedFromJsonException catch (error) {
    return TmdbResponseException('Неверный ответ TMDB.', cause: error);
  }
}

String _httpFallback(int? httpStatus) {
  return 'Запрос к TMDB не выполнен (HTTP ${httpStatus ?? 0}).';
}

Map<String, dynamic>? _asJsonMap(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map<Object?, Object?>) {
    return _stringKeyedMap(data);
  }
  if (data is! String || data.isEmpty) {
    return null;
  }

  final decoded = jsonDecode(data);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }
  if (decoded is Map<Object?, Object?>) {
    return _stringKeyedMap(decoded);
  }
  return null;
}

Map<String, dynamic> _stringKeyedMap(Map<Object?, Object?> data) {
  final mapped = <String, dynamic>{};
  for (final entry in data.entries) {
    final key = entry.key;
    if (key == null) {
      continue;
    }
    mapped[key.toString()] = entry.value;
  }
  return mapped;
}
