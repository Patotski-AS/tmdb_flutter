import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception_mapper.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/source/dio_tmdb_api.dart';

void main() {
  test('HTTP error throws TmdbHttpException with status message', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'))
      ..httpClientAdapter = _InvalidApiKeyAdapter()
      ..interceptors.add(const TmdbExceptionInterceptor());
    final repository = MovieRepositoryImpl(
      api: DioTmdbApi(dio),
      images: ImageConfigurationCache(),
    );

    await expectLater(
      repository.getImageConfiguration(),
      throwsA(
        isA<TmdbHttpException>()
            .having(
              (error) => error.statusMessage,
              'statusMessage',
              'Invalid API key',
            )
            .having((error) => error.statusCode, 'statusCode', 7),
      ),
    );
  });

  test('requests send language and omit null discover filters', () async {
    final adapter = _ScriptedAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'))
      ..httpClientAdapter = adapter
      ..interceptors.add(const TmdbExceptionInterceptor());
    final api = DioTmdbApi(dio);
    final repository = MovieRepositoryImpl(
      api: api,
      images: ImageConfigurationCache(),
    );

    final page = await repository.getPopularMovies();
    final images = await repository.getImageConfiguration();

    expect(page.items, hasLength(2));
    expect(page.items.first.title, 'Бойцовский клуб');
    expect(page.items.first.overview, 'Описание');
    expect(page.items.first.voteAverage, 8.4);
    expect(page.items.first.releaseDate, '1999-10-15');
    expect(
      page.items.first.posterUrl,
      'https://image.tmdb.org/t/p/w500/fight.jpg',
    );
    expect(page.items[1].overview, isEmpty);
    expect(page.items[1].posterUrl, isNull);
    expect(page.items[1].voteAverage, 0);
    expect(images.posterSize, 'w500');
    expect(images.backdropSize, 'w300');
    expect(images.profileSize, 'w185');
    expect(
      adapter.requests.where(
        (request) => request.uri.path.endsWith('/configuration'),
      ),
      hasLength(1),
    );

    await api.discoverMovies(page: 2);
    await api.discoverTvShows(
      page: 3,
      genreId: 28,
      sortBy: 'vote_average.desc',
    );
    await api.searchMovies(query: 'дюна', page: 1);
    await api.getMovieGenres();

    final popular = _requestEnding(adapter, '/movie/popular');
    expect(popular.queryParameters['language'], 'ru-RU');
    expect(popular.queryParameters['page'], 1);
    expect(popular.queryParameters.containsKey('include_adult'), isFalse);

    final plain = _requestEnding(adapter, '/discover/movie');
    expect(plain.queryParameters['language'], 'ru-RU');
    expect(plain.queryParameters['page'], 2);
    expect(plain.queryParameters.containsKey('with_genres'), isFalse);
    expect(plain.queryParameters.containsKey('sort_by'), isFalse);

    final filtered = _requestEnding(adapter, '/discover/tv');
    expect(filtered.queryParameters['with_genres'], 28);
    expect(filtered.queryParameters['sort_by'], 'vote_average.desc');
    expect(filtered.queryParameters.containsKey('include_adult'), isFalse);

    final search = _requestEnding(adapter, '/search/movie');
    expect(search.queryParameters['language'], 'ru-RU');
    expect(search.queryParameters['query'], 'дюна');
    expect(search.queryParameters['page'], 1);
    expect(search.queryParameters['include_adult'], false);

    final genres = _requestEnding(adapter, '/genre/movie/list');
    expect(genres.queryParameters['language'], 'ru-RU');
    expect(genres.queryParameters.containsKey('page'), isFalse);

    final configuration = _requestEnding(adapter, '/configuration');
    expect(configuration.queryParameters['language'], 'ru-RU');

    await api.getMovieDetails(id: 550);
    await api.getTvShowDetails(id: 1396);

    final movie = _requestEnding(adapter, '/movie/550');
    expect(movie.queryParameters['language'], 'ru-RU');
    expect(
      movie.queryParameters['append_to_response'],
      'credits,videos,images,recommendations',
    );
    expect(movie.queryParameters.containsKey('page'), isFalse);

    final show = _requestEnding(adapter, '/tv/1396');
    expect(show.queryParameters['language'], 'ru-RU');
    expect(
      show.queryParameters['append_to_response'],
      'credits,videos,images,recommendations',
    );
  });
}

RequestOptions _requestEnding(_ScriptedAdapter adapter, String suffix) {
  return adapter.requests.lastWhere(
    (request) => request.uri.path.endsWith(suffix),
  );
}

final class _InvalidApiKeyAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"status_code":7,"status_message":"Invalid API key"}',
      401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final class _ScriptedAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      _bodyFor(options.uri.path),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

String _bodyFor(String path) {
  if (path.endsWith('/configuration')) {
    return _configurationBody;
  }
  if (path.endsWith('/movie/popular')) {
    return _moviePageBody;
  }
  if (RegExp(r'/movie/\d+$').hasMatch(path)) {
    return _movieDetailsBody;
  }
  if (RegExp(r'/tv/\d+$').hasMatch(path)) {
    return _tvDetailsBody;
  }
  return _emptyPageBody;
}

const _emptyPageBody = '''
{"page":1,"results":[],"total_pages":0,"total_results":0}
''';

const _moviePageBody = '''
{
  "page": 1,
  "results": [
    {
      "id": 550,
      "title": "Бойцовский клуб",
      "overview": "Описание",
      "poster_path": "/fight.jpg",
      "vote_average": 8.4,
      "release_date": "1999-10-15",
      "adult": false,
      "original_title": "Fight Club"
    },
    {"id": 2, "title": "Пустой", "poster_path": null}
  ],
  "total_pages": 1,
  "total_results": 2
}
''';

const _movieDetailsBody = '''
{"id":550,"title":"Бойцовский клуб","unknown_field":"ignored","budget":0}
''';

const _tvDetailsBody = '''
{
  "id": 1396,
  "name": "Во все тяжкие",
  "unknown_field": true,
  "episode_run_time": [47, 0],
  "number_of_seasons": 5
}
''';

const _configurationBody = '''
{
  "images": {
    "base_url": "http://image.tmdb.org/t/p/",
    "secure_base_url": "https://image.tmdb.org/t/p/",
    "poster_sizes": ["w92", "original"],
    "backdrop_sizes": ["w300", "original"],
    "profile_sizes": ["w45"]
  },
  "change_keys": ["adult"]
}
''';
