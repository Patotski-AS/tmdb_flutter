import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';
import 'package:tmdb_flutter/core/network/tmdb_session_interceptor.dart';
import 'package:tmdb_flutter/data/account/account_api.dart';
import 'package:tmdb_flutter/data/account/dto/favorite_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';

const String _language = 'ru-RU';

/// [AccountApi] implemented with [Dio].
///
/// A [DioException] is unwrapped to the [TmdbException] stored in
/// `DioException.error`, or mapped when the interceptor did not run.
final class DioAccountApi implements AccountApi {
  /// Creates a client that sends account requests through [dio].
  const new(this.dio);

  /// HTTP client pointed at the TMDB v3 root.
  final Dio dio;

  @override
  Future<bool> isFavorite({required int movieId}) async {
    final body = await _get(
      'movie/$movieId/account_states',
      decode: MovieAccountStatesDto.fromJson,
    );
    return body.favorite;
  }

  @override
  Future<void> setFavorite({
    required int accountId,
    required int movieId,
    required bool favorite,
  }) async {
    try {
      await dio.post<Object?>(
        'account/$accountId/favorite',
        data: FavoriteRequestDto(
          mediaType: 'movie',
          mediaId: movieId,
          favorite: favorite,
        ).toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          extra: const {attachTmdbSessionKey: true},
        ),
      );
    } on DioException catch (error) {
      throw _asTmdbException(error);
    }
  }

  @override
  Future<PopularMoviesResponseDto> getFavoriteMovies({
    required int accountId,
    required int page,
  }) {
    return _get(
      'account/$accountId/favorite/movies',
      decode: PopularMoviesResponseDto.fromJson,
      queryParameters: {'language': _language, 'page': page},
    );
  }

  Future<T> _get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) decode,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: Options(extra: const {attachTmdbSessionKey: true}),
      );
      return decode(_jsonObject(response.data));
    } on DioException catch (error) {
      throw _asTmdbException(error);
    } on CheckedFromJsonException catch (error) {
      throw TmdbResponseException('Неверный ответ TMDB.', cause: error);
    }
  }
}

Map<String, dynamic> _jsonObject(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map<Object?, Object?>) {
    final json = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      if (key is! String) {
        throw const TmdbResponseException('Неверный ответ TMDB.');
      }
      json[key] = entry.value;
    }
    return json;
  }
  throw const TmdbResponseException('Неверный ответ TMDB.');
}

TmdbException _asTmdbException(DioException error) {
  final cause = error.error;
  if (cause is TmdbException) {
    return cause;
  }
  return mapDioException(error);
}
