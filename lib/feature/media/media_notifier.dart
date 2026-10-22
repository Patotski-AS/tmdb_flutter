import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb_flutter/core/network/tmdb_exception.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_sort_option.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/paged.dart';
import 'package:tmdb_flutter/data/tmdb/model/person.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/tmdb_providers.dart';
import 'package:tmdb_flutter/feature/media/media_state.dart';

part 'media_notifier.g.dart';

const _searchDebounce = Duration(milliseconds: 400);

typedef _LoadedPage = ({List<MediaItem> items, int page, int totalPages});

/// Catalog list: popular, search, and discover.
@riverpod
class MediaNotifier extends _$MediaNotifier {
  Timer? _searchTimer;

  /// Invalidates responses from an older type, query, or page load.
  int _generation = 0;

  @override
  MediaState build() {
    ref.onDispose(_cancelSearch);
    unawaited(
      Future<void>.microtask(() {
        if (!ref.mounted) return;
        unawaited(_loadMovieGenres());
        unawaited(_loadTvGenres());
        _loadInitial(force: true);
      }),
    );
    return const MediaState(isLoading: true);
  }

  /// Switches the catalog section and reloads popular titles.
  ///
  /// Selecting the current section does nothing.
  void selectContentType(MediaContentType contentType) {
    if (state.contentType == contentType) return;
    _cancelSearch();
    _generation++;
    state = state.copyWith(
      contentType: contentType,
      searchQuery: '',
      filters: const MediaFilters(),
      items: const [],
      page: 0,
      endReached: false,
      isLoading: false,
      isLoadingMore: false,
      error: null,
    );
    _loadInitial(force: true);
  }

  /// Updates the search text.
  ///
  /// A blank value reloads popular titles immediately. Any other change
  /// clears the list and waits 400 milliseconds before searching.
  void onQueryChanged(String query) {
    final previous = state.searchQuery;
    _cancelSearch();
    if (query != previous) {
      _generation++;
      state = state.copyWith(
        searchQuery: query,
        items: const [],
        page: 0,
        endReached: false,
        isLoading: query.trim().isNotEmpty,
        isLoadingMore: false,
        error: null,
      );
    }
    if (query.trim().isEmpty) {
      _loadInitial(force: true);
      return;
    }
    _searchTimer = Timer(_searchDebounce, () {
      if (!ref.mounted) return;
      _loadInitial(force: true);
    });
  }

  /// Clears the search field and reloads popular titles.
  void clearQuery() => onQueryChanged('');

  /// Applies [filters] and reloads the first page.
  void applyFilters(MediaFilters filters) {
    _cancelSearch();
    state = state.copyWith(filters: filters);
    _loadInitial(force: true);
  }

  /// Clears the genre and sort, then reloads the first page.
  void resetFilters() => applyFilters(const MediaFilters());

  /// Reloads the first page. Used by the retry button.
  void load() => _loadInitial(force: true);

  /// Appends the next page when one is available.
  void loadMore() {
    if (state.isLoadingMore || state.endReached || state.isLoading) return;
    unawaited(_loadPage(page: state.page + 1, append: true));
  }

  void _cancelSearch() {
    _searchTimer?.cancel();
    _searchTimer = null;
  }

  void _loadInitial({bool force = false}) {
    if (!ref.mounted) return;
    if (!force && (state.items.isNotEmpty || state.isLoading)) return;
    unawaited(_loadPage(page: 1, append: false));
  }

  bool _isCurrent(
    int generation,
    MediaContentType contentType,
    String searchQuery,
  ) {
    if (!ref.mounted || generation != _generation) return false;
    return state.contentType == contentType && state.searchQuery == searchQuery;
  }

  Future<void> _loadMovieGenres() async {
    try {
      final genres = await ref.read(movieRepositoryProvider).getMovieGenres();
      if (!ref.mounted) return;
      state = state.copyWith(movieGenres: genres);
    } on TmdbException {
      // A genre failure leaves the list empty and does not surface an error.
    }
  }

  Future<void> _loadTvGenres() async {
    try {
      final genres = await ref.read(tvRepositoryProvider).getTvGenres();
      if (!ref.mounted) return;
      state = state.copyWith(tvGenres: genres);
    } on TmdbException {
      // A genre failure leaves the list empty and does not surface an error.
    }
  }

  Future<void> _loadPage({required int page, required bool append}) async {
    if (!ref.mounted) return;
    final generation = append ? _generation : ++_generation;
    final contentType = state.contentType;
    final searchQuery = state.searchQuery;
    final filters = state.filters;
    state = append
        ? state.copyWith(isLoadingMore: true, error: null)
        : state.copyWith(isLoading: true, isLoadingMore: false, error: null);

    try {
      final loaded = await _loadContent(
        generation: generation,
        contentType: contentType,
        searchQuery: searchQuery,
        filters: filters,
        page: page,
      );
      if (loaded == null || !_isCurrent(generation, contentType, searchQuery)) {
        return;
      }
      state = state.copyWith(
        items: append ? _mergeItems(state.items, loaded.items) : loaded.items,
        page: loaded.page,
        endReached: loaded.page >= loaded.totalPages,
        isLoading: false,
        isLoadingMore: false,
      );
    } on TmdbException catch (error) {
      if (!_isCurrent(generation, contentType, searchQuery)) return;
      state = state.copyWith(
        error: error.message,
        items: append ? state.items : const <MediaItem>[],
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }

  Future<_LoadedPage?> _loadContent({
    required int generation,
    required MediaContentType contentType,
    required String searchQuery,
    required MediaFilters filters,
    required int page,
  }) {
    return switch (contentType) {
      MediaContentType.movies => _loadMovies(
        generation: generation,
        contentType: contentType,
        searchQuery: searchQuery,
        filters: filters,
        page: page,
      ),
      MediaContentType.tv => _loadTv(
        generation: generation,
        contentType: contentType,
        searchQuery: searchQuery,
        filters: filters,
        page: page,
      ),
      MediaContentType.people => _loadPeople(
        generation: generation,
        contentType: contentType,
        searchQuery: searchQuery,
        page: page,
      ),
    };
  }

  Future<_LoadedPage?> _loadMovies({
    required int generation,
    required MediaContentType contentType,
    required String searchQuery,
    required MediaFilters filters,
    required int page,
  }) async {
    final repository = ref.read(movieRepositoryProvider);
    final query = searchQuery.trim();
    final sortBy = _sortBy(filters, contentType);

    if (query.isNotEmpty && filters.isActive) {
      final discovered = await repository.discoverMovies(
        genreId: filters.genreId,
        sortBy: sortBy,
        page: page,
      );
      if (!_isCurrent(generation, contentType, searchQuery)) return null;
      return _moviesPage(_filterMovies(discovered, query));
    }
    if (query.isNotEmpty) {
      final found = await repository.searchMovies(query, page);
      if (!_isCurrent(generation, contentType, searchQuery)) return null;
      return _moviesPage(found);
    }
    if (filters.isActive) {
      final discovered = await repository.discoverMovies(
        genreId: filters.genreId,
        sortBy: sortBy,
        page: page,
      );
      if (!_isCurrent(generation, contentType, searchQuery)) return null;
      return _moviesPage(discovered);
    }
    final popular = await repository.getPopularMovies(page);
    if (!_isCurrent(generation, contentType, searchQuery)) return null;
    return _moviesPage(popular);
  }

  Future<_LoadedPage?> _loadTv({
    required int generation,
    required MediaContentType contentType,
    required String searchQuery,
    required MediaFilters filters,
    required int page,
  }) async {
    final repository = ref.read(tvRepositoryProvider);
    final query = searchQuery.trim();
    final sortBy = _sortBy(filters, contentType);

    if (query.isNotEmpty && filters.isActive) {
      final discovered = await repository.discoverTvShows(
        genreId: filters.genreId,
        sortBy: sortBy,
        page: page,
      );
      if (!_isCurrent(generation, contentType, searchQuery)) return null;
      return _tvPage(_filterTv(discovered, query));
    }
    if (query.isNotEmpty) {
      final found = await repository.searchTvShows(query, page);
      if (!_isCurrent(generation, contentType, searchQuery)) return null;
      return _tvPage(found);
    }
    if (filters.isActive) {
      final discovered = await repository.discoverTvShows(
        genreId: filters.genreId,
        sortBy: sortBy,
        page: page,
      );
      if (!_isCurrent(generation, contentType, searchQuery)) return null;
      return _tvPage(discovered);
    }
    final popular = await repository.getPopularTvShows(page);
    if (!_isCurrent(generation, contentType, searchQuery)) return null;
    return _tvPage(popular);
  }

  Future<_LoadedPage?> _loadPeople({
    required int generation,
    required MediaContentType contentType,
    required String searchQuery,
    required int page,
  }) async {
    final repository = ref.read(personRepositoryProvider);
    final query = searchQuery.trim();
    final found = query.isNotEmpty
        ? await repository.searchPeople(query, page)
        : await repository.getPopularPeople(page);
    if (!_isCurrent(generation, contentType, searchQuery)) return null;
    return (
      items: [for (final person in found.items) _personItem(person)],
      page: found.page,
      totalPages: found.totalPages,
    );
  }
}

String? _sortBy(MediaFilters filters, MediaContentType contentType) {
  return MediaSortOption.fromSortBy(filters.sortBy)?.sortBy(contentType);
}

Paged<Movie> _filterMovies(Paged<Movie> page, String query) {
  final needle = query.toLowerCase();
  final items = [
    for (final movie in page.items)
      if (movie.title.toLowerCase().contains(needle)) movie,
  ];
  return Paged(
    items: items,
    page: page.page,
    totalPages: page.totalPages,
    totalResults: items.length,
  );
}

Paged<TvShow> _filterTv(Paged<TvShow> page, String query) {
  final needle = query.toLowerCase();
  final items = [
    for (final show in page.items)
      if (show.title.toLowerCase().contains(needle)) show,
  ];
  return Paged(
    items: items,
    page: page.page,
    totalPages: page.totalPages,
    totalResults: items.length,
  );
}

_LoadedPage _moviesPage(Paged<Movie> page) {
  return (
    items: [for (final movie in page.items) _movieItem(movie)],
    page: page.page,
    totalPages: page.totalPages,
  );
}

_LoadedPage _tvPage(Paged<TvShow> page) {
  return (
    items: [for (final show in page.items) _tvItem(show)],
    page: page.page,
    totalPages: page.totalPages,
  );
}

MediaItem _movieItem(Movie movie) {
  return MediaItem(
    id: movie.id,
    title: movie.title,
    posterUrl: movie.posterUrl,
    voteAverage: movie.voteAverage,
  );
}

MediaItem _tvItem(TvShow show) {
  return MediaItem(
    id: show.id,
    title: show.title,
    posterUrl: show.posterUrl,
    voteAverage: show.voteAverage,
  );
}

MediaItem _personItem(Person person) {
  return MediaItem(
    id: person.id,
    title: person.name,
    posterUrl: person.profileUrl,
    voteAverage: 0,
    subtitle: person.knownForDepartment,
  );
}

List<MediaItem> _mergeItems(List<MediaItem> current, List<MediaItem> incoming) {
  final seen = <int>{for (final item in current) item.id};
  final merged = [...current];
  for (final item in incoming) {
    if (seen.add(item.id)) merged.add(item);
  }
  return merged;
}
