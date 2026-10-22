import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/dto/configuration_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/movie_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/person_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';
import 'package:tmdb_flutter/data/tmdb/model/person_credit.dart';
import 'package:tmdb_flutter/data/tmdb/repository/image_configuration_cache.dart';
import 'package:tmdb_flutter/data/tmdb/repository/person_repository_impl.dart';
import 'package:tmdb_flutter/data/tmdb/source/tmdb_api.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/person/person_notifier.dart';
import 'package:tmdb_flutter/feature/person/person_state.dart';

const _base = 'https://image.tmdb.org/t/p/';

const _configuration = ConfigurationResponseDto(
  images: ImagesDto(
    secureBaseUrl: _base,
    posterSizes: ['w92', 'w500'],
    backdropSizes: ['w300', 'w780'],
    profileSizes: ['w45', 'w185'],
  ),
);

const _directorDetails = PersonDetailsDto(
  id: 1,
  name: 'Режиссёр',
  knownForDepartment: 'Directing',
  combinedCredits: CombinedCreditsDto(
    crew: [
      PersonCreditDto(
        id: 10,
        title: 'Фильм',
        releaseDate: '2020-01-01',
        voteAverage: 7,
        job: 'Director',
        posterPath: '/film.jpg',
      ),
      PersonCreditDto(
        id: 10,
        title: 'Фильм',
        releaseDate: '2020-01-01',
        voteAverage: 9,
        job: 'Producer',
      ),
      PersonCreditDto(
        id: 11,
        mediaType: 'tv',
        name: 'Сериал',
        firstAirDate: '2019-05-01',
        voteAverage: 8,
        job: 'Creator',
      ),
      PersonCreditDto(
        id: 12,
        mediaType: 'episode',
        title: 'Серия',
        job: 'Director',
      ),
    ],
  ),
);

void main() {
  test(
    'combined credits split cast and crew without another request',
    () async {
      final api = _PersonApi();
      final container = _container(api);
      _listen(container, 287);

      final state = await _ready(
        container,
        287,
        () => _read(container, 287).name != null,
      );

      expect(api.detailCalls, 1);
      expect(api.detailIds, [287]);
      expect(state.name, 'Брэд Питт');
      expect(state.biography, isNull);
      expect(state.deathday, isNull);
      expect(state.birthday, '1963-12-18');
      expect(state.placeOfBirth, 'Шони, Оклахома, США');
      expect(state.knownForDepartment, 'Актёрское искусство');
      expect(state.profileUrl, '${_base}w185/brad.jpg');
      expect(state.alsoKnownAs, ['Уильям Брэдли Питт', 'Брэд Питт']);
      expect(state.showFullCastCredits, isFalse);
      expect(state.showFullCrewCredits, isFalse);

      expect(state.castCredits.map((credit) => credit.id), [
        550,
        807,
        1396,
        12,
        1008,
        1007,
        1006,
        1005,
        1004,
        1003,
        1002,
        1001,
        1000,
      ]);
      expect(
        state.castCredits.where((credit) => credit.id == 550),
        hasLength(1),
      );
      final fight = state.castCredits.first;
      expect(fight.title, 'Бойцовский клуб');
      expect(fight.characterOrJob, 'Тайлер Дёрден');
      expect(fight.posterUrl, '${_base}w500/fight.jpg');
      expect(fight.releaseDate, '1999-10-15');
      expect(fight.voteAverage, 8.4);
      expect(fight.mediaType, PersonCreditMediaType.movie);
      expect(fight.isCast, isTrue);
      expect(state.castCredits[1].title, 'Семь');
      expect(state.castCredits[1].characterOrJob, 'Миллс');
      expect(state.castCredits[2].mediaType, PersonCreditMediaType.tv);
      expect(state.castCredits[2].characterOrJob, 'Гость');
      expect(state.castCredits[3].characterOrJob, isNull);

      expect(state.knownFor.map((credit) => credit.id), [
        1396,
        807,
        550,
        1008,
        12,
        1007,
        1006,
        1005,
      ]);
      expect(state.crewCredits.map((credit) => credit.characterOrJob), [
        'Writer',
        'Producer',
      ]);
      expect(state.crewCredits.every((credit) => !credit.isCast), isTrue);
      expect(_creditIds(state), isNot(contains(99)));
      expect(_creditIds(state), isNot(contains(100)));
      expect(_creditIds(state), isNot(contains(77)));

      container.read(personProvider(287).notifier).showFullCastCredits();
      container.read(personProvider(287).notifier).showFullCrewCredits();
      final expanded = _read(container, 287);
      expect(expanded.showFullCastCredits, isTrue);
      expect(expanded.showFullCrewCredits, isTrue);
      expect(expanded.castCredits, hasLength(13));
      expect(api.detailCalls, 1);
    },
  );

  test('known for uses crew when there is no cast', () async {
    final api = _PersonApi(details: _directorDetails);
    final container = _container(api);
    _listen(container, 1);

    final state = await _ready(
      container,
      1,
      () => _read(container, 1).name != null,
    );

    expect(state.castCredits, isEmpty);
    expect(state.biography, isNull);
    expect(state.knownForDepartment, 'Режиссура');
    expect(state.knownFor.map((credit) => credit.id), [10, 11]);
    expect(state.knownFor.map((credit) => credit.characterOrJob), [
      'Producer',
      'Creator',
    ]);
    expect(state.crewCredits.map((credit) => credit.characterOrJob), [
      'Director',
      'Producer',
      'Creator',
    ]);
    expect(_creditIds(state), isNot(contains(12)));
    expect(api.detailCalls, 1);
  });

  test('load during a request does not start another', () async {
    final gate = Completer<PersonDetailsDto>();
    final api = _PersonApi()..gate = gate;
    final container = _container(api);
    _listen(container, 287);

    await _ready(container, 287, () => api.detailCalls == 1);
    await container.read(personProvider(287).notifier).load();
    expect(api.detailCalls, 1);

    gate.complete(_bradDetails());
    final state = await _ready(
      container,
      287,
      () => _read(container, 287).name != null,
    );
    expect(state.name, 'Брэд Питт');
    expect(api.detailCalls, 1);
  });

  test('failed load keeps the exception message', () async {
    final api = _PersonApi()
      ..error = const TmdbNetworkException('Сеть недоступна');
    final container = _container(api);
    _listen(container, 287);

    final state = await _ready(
      container,
      287,
      () => _read(container, 287).error != null,
    );

    expect(state.error, 'Сеть недоступна');
    expect(state.name, isNull);
    expect(state.isLoading, isFalse);
    expect(api.detailCalls, 1);
  });
}

List<int> _creditIds(PersonState state) {
  return [
    for (final credit in [...state.castCredits, ...state.crewCredits])
      credit.id,
  ];
}

PersonDetailsDto _bradDetails() {
  return PersonDetailsDto(
    id: 287,
    name: 'Брэд Питт',
    biography: '   ',
    profilePath: '/brad.jpg',
    knownForDepartment: 'Acting',
    birthday: '1963-12-18',
    deathday: '',
    placeOfBirth: 'Шони, Оклахома, США',
    alsoKnownAs: const [
      'Уильям Брэдли Питт',
      '',
      'Уильям Брэдли Питт',
      '   ',
      'Брэд Питт',
    ],
    combinedCredits: CombinedCreditsDto(
      cast: [
        const PersonCreditDto(
          id: 550,
          title: 'Бойцовский клуб',
          name: 'Не это имя',
          posterPath: '/fight.jpg',
          releaseDate: '1999-10-15',
          voteAverage: 8.4,
          character: 'Тайлер Дёрден',
        ),
        const PersonCreditDto(
          id: 550,
          title: 'Бойцовский клуб',
          releaseDate: '2001-01-01',
          voteAverage: 1,
          character: 'Тайлер Дёрден',
        ),
        const PersonCreditDto(
          id: 807,
          title: '   ',
          name: 'Семь',
          releaseDate: '1995-09-22',
          voteAverage: 8.6,
          character: 'Миллс',
        ),
        const PersonCreditDto(
          id: 99,
          mediaType: 'person',
          title: 'Лишнее',
          character: 'Кто-то',
        ),
        const PersonCreditDto(id: 100, title: ' ', name: ''),
        const PersonCreditDto(
          id: 1396,
          mediaType: 'TV',
          name: 'Друзья',
          firstAirDate: '1994-09-22',
          voteAverage: 8.9,
          character: 'Гость',
        ),
        const PersonCreditDto(
          id: 12,
          title: 'Один дома',
          releaseDate: '1990-11-16',
          voteAverage: 7.5,
          character: '   ',
        ),
        for (var index = 0; index < 9; index++)
          PersonCreditDto(
            id: 1000 + index,
            title: 'Фильм $index',
            releaseDate: '198$index-06-01',
            voteAverage: index + 0.1,
            character: 'Роль $index',
          ),
      ],
      crew: const [
        PersonCreditDto(
          id: 16869,
          title: 'Бесславные ублюдки',
          releaseDate: '2010-01-01',
          voteAverage: 7,
          job: 'Writer',
        ),
        PersonCreditDto(
          id: 16869,
          title: 'Бесславные ублюдки',
          releaseDate: '2009-08-21',
          voteAverage: 8.2,
          job: 'Producer',
        ),
        PersonCreditDto(
          id: 77,
          mediaType: 'episode',
          title: 'Серия',
          job: 'Director',
        ),
      ],
    ),
  );
}

ProviderContainer _container(_PersonApi api) {
  final images = ImageConfigurationCache();
  final container = ProviderContainer(
    overrides: [
      personRepositoryProvider.overrideWithValue(
        PersonRepositoryImpl(api: api, images: images),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void _listen(ProviderContainer container, int id) {
  container.listen(personProvider(id), (_, _) {});
}

PersonState _read(ProviderContainer container, int id) {
  return container.read(personProvider(id));
}

Future<PersonState> _ready(
  ProviderContainer container,
  int id,
  bool Function() ready,
) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    if (ready()) {
      return _read(container, id);
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('person state did not settle');
}

final class _PersonApi implements TmdbApi {
  new({PersonDetailsDto? details}) : details = details ?? _bradDetails();

  PersonDetailsDto details;
  TmdbException? error;
  Completer<PersonDetailsDto>? gate;
  int detailCalls = 0;
  final detailIds = <int>[];

  @override
  Future<ConfigurationResponseDto> getConfiguration() async {
    return _configuration;
  }

  @override
  Future<PersonDetailsDto> getPersonDetails({required int id}) {
    detailCalls += 1;
    detailIds.add(id);
    final failure = error;
    if (failure != null) {
      return Future<PersonDetailsDto>.error(failure);
    }
    final pending = gate;
    if (pending != null) {
      return pending.future;
    }
    return Future<PersonDetailsDto>.value(details);
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
