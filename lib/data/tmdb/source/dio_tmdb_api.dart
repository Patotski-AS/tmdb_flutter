import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

const String _language = 'ru-RU';

/// [TmdbApi] implemented with [Dio].
///
/// A [DioException] is unwrapped to the [TmdbException] stored in
/// `DioException.error`, or mapped when the interceptor did not run.
final class DioTmdbApi implements TmdbApi {
  /// Creates a client that sends requests through [dio].
  const new(this.dio);

  /// HTTP client pointed at the TMDB v3 root.
  final Dio dio;

  @override
  Future<GenreListResponseDto> getMovieGenres() {
    return _get(
      'genre/movie/list',
      decode: GenreListResponseDto.fromJson,
      queryParameters: _query(),
    );
  }

  @override
  Future<GenreListResponseDto> getTvGenres() {
    return _get(
      'genre/tv/list',
      decode: GenreListResponseDto.fromJson,
      queryParameters: _query(),
    );
  }

  @override
  Future<PopularMoviesResponseDto> getPopularMovies({required int page}) {
    return _get(
      'movie/popular',
      decode: PopularMoviesResponseDto.fromJson,
      queryParameters: _query(page: page),
    );
  }

  @override
  Future<PopularTvResponseDto> getPopularTvShows({required int page}) {
    return _get(
      'tv/popular',
      decode: PopularTvResponseDto.fromJson,
      queryParameters: _query(page: page),
    );
  }

  @override
  Future<PopularPeopleResponseDto> getPopularPeople({required int page}) {
    return _get(
      'person/popular',
      decode: PopularPeopleResponseDto.fromJson,
      queryParameters: _query(page: page),
    );
  }

  @override
  Future<PopularMoviesResponseDto> searchMovies({
    required String query,
    required int page,
  }) {
    return _get(
      'search/movie',
      decode: PopularMoviesResponseDto.fromJson,
      queryParameters: _query(page: page, query: query, hideAdult: true),
    );
  }

  @override
  Future<PopularTvResponseDto> searchTvShows({
    required String query,
    required int page,
  }) {
    return _get(
      'search/tv',
      decode: PopularTvResponseDto.fromJson,
      queryParameters: _query(page: page, query: query, hideAdult: true),
    );
  }

  @override
  Future<PopularPeopleResponseDto> searchPeople({
    required String query,
    required int page,
  }) {
    return _get(
      'search/person',
      decode: PopularPeopleResponseDto.fromJson,
      queryParameters: _query(page: page, query: query, hideAdult: true),
    );
  }

  @override
  Future<PopularMoviesResponseDto> discoverMovies({
    required int page,
    int? genreId,
    String? sortBy,
  }) {
    return _get(
      'discover/movie',
      decode: PopularMoviesResponseDto.fromJson,
      queryParameters: _query(page: page, genreId: genreId, sortBy: sortBy),
    );
  }

  @override
  Future<PopularTvResponseDto> discoverTvShows({
    required int page,
    int? genreId,
    String? sortBy,
  }) {
    return _get(
      'discover/tv',
      decode: PopularTvResponseDto.fromJson,
      queryParameters: _query(page: page, genreId: genreId, sortBy: sortBy),
    );
  }

  @override
  Future<ConfigurationResponseDto> getConfiguration() {
    return _get(
      'configuration',
      decode: ConfigurationResponseDto.fromJson,
      queryParameters: _query(),
    );
  }

  Future<T> _get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) decode,
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await dio.get<Object?>(
        path,
        queryParameters: queryParameters,
      );
      return decode(_jsonObject(response.data));
    } on DioException catch (error) {
      throw _asTmdbException(error);
    } on CheckedFromJsonException catch (error) {
      throw TmdbResponseException('Неверный ответ TMDB.', cause: error);
    }
  }
}

Map<String, dynamic> _query({
  int? page,
  String? query,
  int? genreId,
  String? sortBy,
  bool hideAdult = false,
}) {
  return {
    'language': _language,
    'page': ?page,
    'query': ?query,
    'with_genres': ?genreId,
    'sort_by': ?sortBy,
    if (hideAdult) 'include_adult': false,
  };
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
