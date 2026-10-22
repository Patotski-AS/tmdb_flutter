import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/app/router.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/repository/tv_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/details/details_notifier.dart';
import 'package:tmdb_flutter/feature/details/details_page.dart';
import 'package:tmdb_flutter/feature/details/details_state.dart';

const _base = 'https://image.tmdb.org/t/p/';

const _configuration = ConfigurationResponseDto(
  images: ImagesDto(
    secureBaseUrl: _base,
    posterSizes: ['w92', 'w500'],
    backdropSizes: ['w300', 'w780'],
    profileSizes: ['w45', 'w185'],
  ),
);

const _movieDetails = MovieDetailsDto(
  id: 550,
  title: 'Бойцовский клуб',
  overview: 'Клубы',
  posterPath: '/poster.jpg',
  backdropPath: '/back.jpg',
  tagline: 'Правило',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
  runtime: 139,
  genres: [GenreDto(id: 18, name: 'драма')],
  originalTitle: 'Fight Club',
  status: 'Выпущен',
  originalLanguage: 'en',
  budget: 63000000,
  credits: CreditsDto(
    cast: [
      CastMemberDto(
        id: 819,
        name: 'Эдвард Нортон',
        character: 'Рассказчик',
        profilePath: '/ed.jpg',
      ),
    ],
    crew: [
      CrewMemberDto(id: 1, name: 'Дэвид Финчер', job: 'Director'),
      CrewMemberDto(id: 2, name: 'Джим Улс', job: 'Screenplay'),
      CrewMemberDto(id: 3, name: 'Чак Паланик', job: 'Writer'),
      CrewMemberDto(id: 4, name: 'Чак Паланик', job: 'Story'),
      CrewMemberDto(id: 5, name: 'Продюсер', job: 'Producer'),
    ],
  ),
  videos: VideosResponseDto(
    results: [
      VideoDto(
        id: 'v1',
        key: 'clip1',
        name: 'Клип',
        site: 'YouTube',
        type: 'Clip',
        official: true,
      ),
      VideoDto(
        id: 'v2',
        key: 'trail-a',
        name: 'Трейлер',
        site: 'YouTube',
        type: 'Trailer',
      ),
      VideoDto(
        id: 'v3',
        key: 'tease',
        name: 'Тизер',
        site: 'YouTube',
        type: 'Teaser',
        official: true,
      ),
      VideoDto(
        id: 'v4',
        key: 'vimeo',
        name: 'Vimeo',
        site: 'Vimeo',
        type: 'Trailer',
        official: true,
      ),
      VideoDto(
        id: 'v5',
        key: 'clip2',
        name: 'Клип 2',
        site: 'youtube',
        type: 'Clip',
      ),
      VideoDto(
        id: 'v6',
        key: 'feat',
        name: 'За кадром',
        site: 'YouTube',
        type: 'Featurette',
      ),
      VideoDto(
        id: 'v7',
        key: 'trail-b',
        name: 'Официальный трейлер',
        site: 'YOUTUBE',
        type: 'Trailer',
        official: true,
      ),
    ],
  ),
  images: ImagesResponseDto(
    backdrops: [ImageDto(filePath: '/frame.jpg', aspectRatio: 1.7, width: 780)],
    posters: [ImageDto(filePath: '/p.jpg')],
  ),
  recommendations: MovieRecommendationsDto(
    results: [
      MovieDto(
        id: 7,
        title: 'Семь',
        posterPath: '/seven.jpg',
        voteAverage: 8.3,
      ),
    ],
  ),
);

const _tvDetails = TvShowDetailsDto(
  id: 1396,
  name: 'Во все тяжкие',
  overview: 'Химия',
  voteAverage: 8.9,
  firstAirDate: '2008-01-20',
  episodeRunTime: [47, 0],
  genres: [GenreDto(id: 18, name: 'драма')],
  numberOfSeasons: 5,
  numberOfEpisodes: 62,
  createdBy: [
    CreatedByDto(id: 1, name: 'Винс Гиллиган'),
    CreatedByDto(id: 2, name: 'Винс Гиллиган'),
    CreatedByDto(id: 3, name: '  '),
  ],
  credits: CreditsDto(
    crew: [
      CrewMemberDto(id: 9, name: 'Мишель Макларен', job: 'Director'),
    ],
  ),
);

void main() {
  test('movie card keeps director, writers, and youtube only', () async {
    final api = _CardApi();
    final container = _container(api);
    _listen(container, DetailsMediaType.movie, 550);

    final state = await _ready(
      container,
      DetailsMediaType.movie,
      550,
      () => _read(container, DetailsMediaType.movie, 550).title != null,
    );

    expect(state.title, 'Бойцовский клуб');
    expect(state.isLoading, isFalse);
    expect(state.error, isNull);
    expect(state.crew.map((member) => member.jobLabel), [
      'Режиссёр',
      'Сценарий',
    ]);
    expect(state.crew[0].name, 'Дэвид Финчер');
    expect(state.crew[1].name, 'Джим Улс, Чак Паланик');
    expect(state.videos.map((video) => video.key), [
      'trail-b',
      'trail-a',
      'tease',
      'clip1',
      'clip2',
      'feat',
    ]);
    expect(state.videos.map((video) => video.typeLabel), [
      'Трейлер',
      'Трейлер',
      'Тизер',
      'Клип',
      'Клип',
      'Featurette',
    ]);
    expect(state.videos.map((video) => video.key), isNot(contains('vimeo')));
    expect(state.budget, 63000000);
    expect(state.revenue, isNull);
    expect(state.numberOfSeasons, isNull);
    expect(state.posterUrl, '${_base}w500/poster.jpg');
    expect(state.backdropUrl, '${_base}w780/back.jpg');
    expect(state.cast.single.profileUrl, '${_base}w185/ed.jpg');
    expect(state.backdrops.single.url, '${_base}w780/frame.jpg');
    expect(state.posters.single.url, '${_base}w500/p.jpg');
    expect(state.recommendations.single.id, 7);
    expect(api.movieIds, [550]);
  });

  test('tv card keeps the creator and the seasons', () async {
    final api = _CardApi();
    final container = _container(api);
    _listen(container, DetailsMediaType.tv, 1396);

    final state = await _ready(
      container,
      DetailsMediaType.tv,
      1396,
      () => _read(container, DetailsMediaType.tv, 1396).title != null,
    );

    expect(state.title, 'Во все тяжкие');
    expect(state.mediaType, DetailsMediaType.tv);
    expect(state.crew.map((member) => member.jobLabel), [
      'Создатель',
      'Режиссёр',
    ]);
    expect(state.crew.first.name, 'Винс Гиллиган');
    expect(state.numberOfSeasons, 5);
    expect(state.numberOfEpisodes, 62);
    expect(state.runtime, 47);
    expect(state.budget, isNull);
    expect(state.revenue, isNull);
    expect(api.tvIds, [1396]);
  });

  test('retry after an error loads the card', () async {
    final api = _CardApi()
      ..movieError = const TmdbNetworkException('Сеть недоступна');
    final container = _container(api);
    _listen(container, DetailsMediaType.movie, 550);

    final failed = await _ready(
      container,
      DetailsMediaType.movie,
      550,
      () => _read(container, DetailsMediaType.movie, 550).error != null,
    );
    expect(failed.title, isNull);
    expect(failed.isLoading, isFalse);
    expect(failed.error, 'Сеть недоступна');
    expect(api.movieDetailCalls, 1);

    api.movieError = null;
    await container
        .read(detailsProvider(DetailsMediaType.movie, 550).notifier)
        .load();
    final loaded = await _ready(
      container,
      DetailsMediaType.movie,
      550,
      () => _read(container, DetailsMediaType.movie, 550).title != null,
    );
    expect(loaded.error, isNull);
    expect(loaded.title, 'Бойцовский клуб');
    expect(api.movieDetailCalls, 2);
  });

  test('recommendation route keeps the media type', () {
    final movie = recommendationRoute(
      mediaType: DetailsMediaType.movie,
      id: 42,
    );
    final show = recommendationRoute(mediaType: DetailsMediaType.tv, id: 42);

    expect(movie, isA<MovieRoute>());
    expect((movie as MovieRoute).id, '42');
    expect(show, isA<TvRoute>());
    expect((show as TvRoute).id, '42');
  });

  test('load during a request does not start another', () async {
    final gate = Completer<MovieDetailsDto>();
    final api = _CardApi()..movieGate = gate;
    final container = _container(api);
    _listen(container, DetailsMediaType.movie, 550);

    await _ready(
      container,
      DetailsMediaType.movie,
      550,
      () => api.movieDetailCalls == 1,
    );
    await container
        .read(detailsProvider(DetailsMediaType.movie, 550).notifier)
        .load();
    expect(api.movieDetailCalls, 1);

    gate.complete(_movieDetails);
    final state = await _ready(
      container,
      DetailsMediaType.movie,
      550,
      () => _read(container, DetailsMediaType.movie, 550).title != null,
    );
    expect(state.title, 'Бойцовский клуб');
    expect(api.movieDetailCalls, 1);
  });
}

ProviderContainer _container(_CardApi api) {
  final images = ImageConfigurationCache();
  final container = ProviderContainer(
    overrides: [
      movieRepositoryProvider.overrideWithValue(
        MovieRepositoryImpl(api: api, images: images),
      ),
      tvRepositoryProvider.overrideWithValue(
        TvRepositoryImpl(api: api, images: images),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void _listen(ProviderContainer container, DetailsMediaType type, int id) {
  container.listen(detailsProvider(type, id), (_, _) {});
}

DetailsState _read(ProviderContainer container, DetailsMediaType type, int id) {
  return container.read(detailsProvider(type, id));
}

Future<DetailsState> _ready(
  ProviderContainer container,
  DetailsMediaType type,
  int id,
  bool Function() ready,
) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    if (ready()) {
      return _read(container, type, id);
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('details state did not settle');
}

final class _CardApi implements TmdbApi {
  TmdbException? movieError;
  Completer<MovieDetailsDto>? movieGate;
  MovieDetailsDto movieDetails = _movieDetails;
  TvShowDetailsDto tvDetails = _tvDetails;
  int movieDetailCalls = 0;
  final movieIds = <int>[];
  final tvIds = <int>[];

  @override
  Future<ConfigurationResponseDto> getConfiguration() async {
    return _configuration;
  }

  @override
  Future<MovieDetailsDto> getMovieDetails({required int id}) {
    movieDetailCalls += 1;
    movieIds.add(id);
    final error = movieError;
    if (error != null) {
      return Future<MovieDetailsDto>.error(error);
    }
    final gate = movieGate;
    if (gate != null) {
      return gate.future;
    }
    return Future<MovieDetailsDto>.value(movieDetails);
  }

  @override
  Future<TvShowDetailsDto> getTvShowDetails({required int id}) {
    tvIds.add(id);
    return Future<TvShowDetailsDto>.value(tvDetails);
  }

  @override
  Future<GenreListResponseDto> getMovieGenres() => _unused();

  @override
  Future<GenreListResponseDto> getTvGenres() => _unused();

  @override
  Future<PopularMoviesResponseDto> getPopularMovies({required int page}) =>
      _unused();

  @override
  Future<PopularTvResponseDto> getPopularTvShows({required int page}) =>
      _unused();

  @override
  Future<PopularPeopleResponseDto> getPopularPeople({required int page}) =>
      _unused();

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
