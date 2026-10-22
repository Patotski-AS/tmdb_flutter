import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/image_configuration.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_sort_option.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/repository/movie_repository.dart';
import 'package:tmdb_flutter/data/tmdb/repository/person_repository.dart';
import 'package:tmdb_flutter/data/tmdb/repository/tv_repository.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/media/media_notifier.dart';

void main() {
  test('loads the first page of popular movies', () async {
    final movies = _FakeMovieRepository(
      popular: {
        1: _page(
          page: 1,
          totalPages: 3,
          items: [_movie(1, 'Дюна'), _movie(2, 'Бегущий')],
        ),
      },
    );
    final container = _container(movies: movies);
    addTearDown(container.dispose);

    await _settle();
    final state = container.read(mediaProvider);

    expect(state.contentType, MediaContentType.movies);
    expect(state.isLoading, isFalse);
    expect(state.error, isNull);
    expect(state.page, 1);
    expect(state.items.map((item) => item.id), [1, 2]);
    expect(state.items.map((item) => item.title), ['Дюна', 'Бегущий']);
    expect(movies.popularPages, [1]);
    expect(movies.searchQueries, isEmpty);
  });

  test('switching to tv clears movies and requests shows', () async {
    final movies = _FakeMovieRepository(
      popular: {
        1: _page(page: 1, totalPages: 1, items: [_movie(1, 'Фильм')]),
      },
    );
    final shows = _FakeTvRepository(
      popular: {
        1: _page(page: 1, totalPages: 1, items: [_show(9, 'Сериал')]),
      },
    );
    final container = _container(movies: movies, shows: shows);
    addTearDown(container.dispose);
    await _settle();

    container
        .read(mediaProvider.notifier)
        .selectContentType(MediaContentType.tv);
    await _settle();
    final state = container.read(mediaProvider);

    expect(state.contentType, MediaContentType.tv);
    expect(state.searchQuery, isEmpty);
    expect(state.items.map((item) => item.title), ['Сериал']);
    expect(state.items.map((item) => item.id), [9]);
    expect(movies.popularPages, [1]);
    expect(shows.popularPages, [1]);
  });

  test('rapid query changes search once with the last text', () {
    fakeAsync((async) {
      final movies = _FakeMovieRepository(
        popular: {
          1: _page(page: 1, totalPages: 1, items: [_movie(1, 'Фильм')]),
        },
      );
      final container = _container(movies: movies);
      addTearDown(container.dispose);
      async.flushMicrotasks();

      container.read(mediaProvider.notifier)
        ..onQueryChanged('a')
        ..onQueryChanged('ab')
        ..onQueryChanged('abc');
      async
        ..elapse(const Duration(milliseconds: 399))
        ..flushMicrotasks();
      expect(movies.searchQueries, isEmpty);

      async
        ..elapse(const Duration(milliseconds: 1))
        ..flushMicrotasks();

      expect(movies.searchQueries, ['abc']);
      expect(movies.popularPages, [1]);
      expect(container.read(mediaProvider).items.single.title, 'abc');
    });
  });

  test('load more requests the next page and appends items', () async {
    final movies = _FakeMovieRepository(
      popular: {
        1: _page(page: 1, totalPages: 2, items: [_movie(1, 'Один')]),
        2: _page(page: 2, totalPages: 2, items: [_movie(2, 'Два')]),
      },
    );
    final container = _container(movies: movies);
    addTearDown(container.dispose);
    await _settle();

    container.read(mediaProvider.notifier).loadMore();
    await _settle();
    final state = container.read(mediaProvider);

    expect(movies.popularPages, [1, 2]);
    expect(state.items.map((item) => item.id), [1, 2]);
    expect(state.items.map((item) => item.title), ['Один', 'Два']);
    expect(state.page, 2);
    expect(state.endReached, isTrue);
  });

  test('load more does not call the repository after the last page', () async {
    final movies = _FakeMovieRepository(
      popular: {
        1: _page(page: 1, totalPages: 1, items: [_movie(1, 'Один')]),
      },
    );
    final container = _container(movies: movies);
    addTearDown(container.dispose);
    await _settle();

    expect(container.read(mediaProvider).endReached, isTrue);
    container.read(mediaProvider.notifier).loadMore();
    await _settle();

    expect(movies.popularPages, [1]);
    expect(container.read(mediaProvider).items, hasLength(1));
  });
}

ProviderContainer _container({
  _FakeMovieRepository? movies,
  _FakeTvRepository? shows,
  _FakePersonRepository? people,
}) {
  final container = ProviderContainer(
    overrides: [
      movieRepositoryProvider.overrideWithValue(
        movies ?? _FakeMovieRepository(),
      ),
      tvRepositoryProvider.overrideWithValue(shows ?? _FakeTvRepository()),
      personRepositoryProvider.overrideWithValue(
        people ?? _FakePersonRepository(),
      ),
    ],
  );
  return container..listen(mediaProvider, (_, _) {});
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Movie _movie(int id, String title) {
  return Movie(
    id: id,
    title: title,
    overview: '',
    posterUrl: null,
    voteAverage: 7,
    releaseDate: null,
  );
}

TvShow _show(int id, String title) {
  return TvShow(
    id: id,
    title: title,
    overview: '',
    posterUrl: null,
    voteAverage: 8,
    firstAirDate: null,
  );
}

Paged<T> _page<T>({
  required List<T> items,
  required int page,
  required int totalPages,
}) {
  return Paged(
    items: items,
    page: page,
    totalPages: totalPages,
    totalResults: items.length,
  );
}

final class _FakeMovieRepository implements MovieRepository {
  new({this.popular = const {}});

  final Map<int, Paged<Movie>> popular;
  final List<int> popularPages = [];
  final List<String> searchQueries = [];

  @override
  Future<List<Genre>> getMovieGenres() async => const [];

  @override
  Future<Paged<Movie>> getPopularMovies([int page = 1]) async {
    popularPages.add(page);
    return popular[page] ?? _page(items: const [], page: page, totalPages: 1);
  }

  @override
  Future<Paged<Movie>> searchMovies(String query, [int page = 1]) async {
    searchQueries.add(query);
    return _page(items: [_movie(100, query)], page: page, totalPages: 1);
  }

  @override
  Future<Paged<Movie>> discoverMovies({
    int? genreId,
    String? sortBy,
    int page = 1,
  }) async {
    return _page(items: const [], page: page, totalPages: 1);
  }

  @override
  Future<ImageConfiguration> getImageConfiguration() async {
    throw UnimplementedError();
  }
}

final class _FakeTvRepository implements TvRepository {
  new({this.popular = const {}});

  final Map<int, Paged<TvShow>> popular;
  final List<int> popularPages = [];

  @override
  Future<List<Genre>> getTvGenres() async => const [];

  @override
  Future<Paged<TvShow>> getPopularTvShows([int page = 1]) async {
    popularPages.add(page);
    return popular[page] ?? _page(items: const [], page: page, totalPages: 1);
  }

  @override
  Future<Paged<TvShow>> searchTvShows(String query, [int page = 1]) async {
    return _page(items: const [], page: page, totalPages: 1);
  }

  @override
  Future<Paged<TvShow>> discoverTvShows({
    int? genreId,
    String? sortBy,
    int page = 1,
  }) async {
    return _page(items: const [], page: page, totalPages: 1);
  }
}

final class _FakePersonRepository implements PersonRepository {
  @override
  Future<Paged<Person>> getPopularPeople([int page = 1]) async {
    return _page(items: const [], page: page, totalPages: 1);
  }

  @override
  Future<Paged<Person>> searchPeople(String query, [int page = 1]) async {
    return _page(items: const [], page: page, totalPages: 1);
  }
}
