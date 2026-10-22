import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_session_interceptor.dart';
import 'package:tmdb_flutter/core/storage/session_storage.dart';
import 'package:tmdb_flutter/core/storage/session_storage_provider.dart';
import 'package:tmdb_flutter/data/account/account_api.dart';
import 'package:tmdb_flutter/data/account/account_exception.dart';
import 'package:tmdb_flutter/data/account/account_repository_impl.dart';
import 'package:tmdb_flutter/data/account/dio_account_api.dart';
import 'package:tmdb_flutter/data/session/session_repository.dart';
import 'package:tmdb_flutter/data/session/session_state.dart';
import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';

const _base = 'https://image.tmdb.org/t/p/';

const _configuration = ConfigurationResponseDto(
  images: ImagesDto(secureBaseUrl: _base, posterSizes: ['w500']),
);

void main() {
  test('guest does not call account endpoints', () async {
    final harness = await _harness();

    await _expectUnauthorized(() => harness.repository.isFavorite(9));
    await _expectUnauthorized(
      () => harness.repository.setFavorite(movieId: 9, favorite: true),
    );
    await _expectUnauthorized(harness.repository.getFavoriteMovies);

    expect(harness.api.calls, isEmpty);
    expect(harness.catalog.configurationCalls, 0);
  });

  test('http 401 logs out and a later error does not', () async {
    final harness = await _harness(
      const StoredSession(sessionId: 'sid', accountId: 7, username: 'neo'),
    );
    harness.api.favoriteError = const TmdbHttpException(
      statusCode: 401,
      statusMessage: 'Invalid session',
      httpStatusCode: 401,
    );

    await expectLater(
      harness.repository.isFavorite(3),
      throwsA(isA<TmdbHttpException>()),
    );

    expect(
      harness.container.read(sessionRepositoryProvider).requireValue,
      const Guest(),
    );
    expect(await harness.storage.read(), isNull);
    expect(harness.api.calls, ['state:3']);

    await harness.container
        .read(sessionRepositoryProvider.notifier)
        .saveSession(sessionId: 'sid', accountId: 7, username: 'neo');
    harness.api
      ..calls.clear()
      ..favoriteError = null
      ..setError = const TmdbHttpException(
        statusCode: 500,
        statusMessage: 'Сервис недоступен',
        httpStatusCode: 500,
      );

    await expectLater(
      harness.repository.setFavorite(movieId: 3, favorite: true),
      throwsA(isA<TmdbHttpException>()),
    );
    expect(
      harness.container.read(sessionRepositoryProvider).requireValue,
      const Authenticated(accountId: 7, username: 'neo'),
    );
  });

  test('favorite movies walk every page and build posters', () async {
    final harness = await _harness(
      const StoredSession(sessionId: 'sid', accountId: 7, username: 'neo'),
    );
    harness.catalog.configuration = _configuration;

    final movies = await harness.repository.getFavoriteMovies();

    expect(harness.api.calls, ['page:7:1', 'page:7:2']);
    expect(movies.map((movie) => movie.id), [1, 2]);
    expect(movies.map((movie) => movie.posterUrl), [
      '${_base}w500/a.jpg',
      '${_base}w500/b.jpg',
    ]);
  });

  test('account requests opt in to the session', () async {
    final adapter = _Adapter();
    final dio = Dio()..httpClientAdapter = adapter;
    addTearDown(dio.close);
    final api = DioAccountApi(dio);

    expect(await api.isFavorite(movieId: 5), isTrue);
    await api.setFavorite(accountId: 7, movieId: 5, favorite: true);
    await api.getFavoriteMovies(accountId: 7, page: 2);

    expect(adapter.requests, hasLength(3));
    expect(adapter.requests[0].path, 'movie/5/account_states');
    expect(adapter.requests[0].extra[attachTmdbSessionKey], isTrue);
    expect(adapter.requests[1].path, 'account/7/favorite');
    expect(adapter.requests[1].data, {
      'media_type': 'movie',
      'media_id': 5,
      'favorite': true,
    });
    expect(adapter.requests[1].extra[attachTmdbSessionKey], isTrue);
    expect(adapter.requests[2].path, 'account/7/favorite/movies');
    expect(adapter.requests[2].queryParameters['language'], 'ru-RU');
    expect(adapter.requests[2].queryParameters['page'], 2);
    expect(adapter.requests[2].extra[attachTmdbSessionKey], isTrue);
  });
}

Future<void> _expectUnauthorized(Future<Object?> Function() call) async {
  try {
    await call();
    fail('expected authorization error');
  } on AccountAuthorizationException catch (error) {
    expect(error.message, 'Необходима авторизация');
  }
}

Future<_Harness> _harness([StoredSession? stored]) async {
  final storage = _Memory(stored);
  final container = ProviderContainer(
    overrides: [sessionStorageProvider.overrideWithValue(storage)],
  );
  addTearDown(container.dispose);
  await container.read(sessionRepositoryProvider.future);
  final api = _AccountApi();
  final catalog = _Catalog();
  return _Harness(
    container: container,
    storage: storage,
    api: api,
    catalog: catalog,
    repository: AccountRepositoryImpl(
      api: api,
      sessions: container.read(sessionRepositoryProvider.notifier),
      images: ImageConfigurationCache(),
      catalog: catalog,
    ),
  );
}

final class _Harness {
  new({
    required this.container,
    required this.storage,
    required this.api,
    required this.catalog,
    required this.repository,
  });

  final ProviderContainer container;
  final _Memory storage;
  final _AccountApi api;
  final _Catalog catalog;
  final AccountRepositoryImpl repository;
}

final class _Memory implements SessionStorage {
  new([this._session]);

  StoredSession? _session;

  @override
  Future<StoredSession?> read() async => _session;

  @override
  Future<void> write(StoredSession session) async {
    _session = session;
  }

  @override
  Future<void> clear() async {
    _session = null;
  }
}

final class _AccountApi implements AccountApi {
  final calls = <String>[];
  TmdbException? favoriteError;
  TmdbException? setError;

  @override
  Future<bool> isFavorite({required int movieId}) async {
    calls.add('state:$movieId');
    final error = favoriteError;
    if (error != null) {
      throw error;
    }
    return true;
  }

  @override
  Future<void> setFavorite({
    required int accountId,
    required int movieId,
    required bool favorite,
  }) async {
    calls.add('set:$accountId:$movieId:$favorite');
    final error = setError;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<PopularMoviesResponseDto> getFavoriteMovies({
    required int accountId,
    required int page,
  }) async {
    calls.add('page:$accountId:$page');
    return PopularMoviesResponseDto(
      page: page,
      totalPages: 2,
      totalResults: 2,
      results: [
        MovieDto(
          id: page,
          title: 'Фильм $page',
          posterPath: page == 1 ? '/a.jpg' : '/b.jpg',
        ),
      ],
    );
  }
}

final class _Catalog implements TmdbApi {
  int configurationCalls = 0;
  ConfigurationResponseDto? configuration;

  @override
  Future<ConfigurationResponseDto> getConfiguration() async {
    configurationCalls += 1;
    final value = configuration;
    if (value == null) {
      throw StateError('configuration');
    }
    return value;
  }

  @override
  Future<GenreListResponseDto> getMovieGenres() => _unused();

  @override
  Future<GenreListResponseDto> getTvGenres() => _unused();

  @override
  Future<PopularMoviesResponseDto> getPopularMovies({required int page}) =>
      _unused();

  @override
  Future<MovieDetailsDto> getMovieDetails({required int id}) => _unused();

  @override
  Future<PopularTvResponseDto> getPopularTvShows({required int page}) =>
      _unused();

  @override
  Future<TvShowDetailsDto> getTvShowDetails({required int id}) => _unused();

  @override
  Future<PopularPeopleResponseDto> getPopularPeople({required int page}) =>
      _unused();

  @override
  Future<PersonDetailsDto> getPersonDetails({required int id}) => _unused();

  @override
  Future<PopularMoviesResponseDto> searchMovies({
    required String query,
    required int page,
  }) => _unused();

  @override
  Future<PopularTvResponseDto> searchTvShows({
    required String query,
    required int page,
  }) => _unused();

  @override
  Future<PopularPeopleResponseDto> searchPeople({
    required String query,
    required int page,
  }) => _unused();

  @override
  Future<PopularMoviesResponseDto> discoverMovies({
    required int page,
    int? genreId,
    String? sortBy,
  }) => _unused();

  @override
  Future<PopularTvResponseDto> discoverTvShows({
    required int page,
    int? genreId,
    String? sortBy,
  }) => _unused();
}

Never _unused() => throw UnimplementedError();

final class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final path = options.path;
    final body = path.contains('account_states')
        ? '{"favorite":true}'
        : path.contains('favorite/movies')
        ? '{"page":2,"results":[],"total_pages":2,"total_results":0}'
        : '{"success":true}';
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
