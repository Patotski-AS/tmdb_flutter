import 'package:flutter/foundation.dart';
import 'package:tmdb_flutter/data/tmdb/model/genre.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_sort_option.dart';

/// Discover filters for movies and TV shows.
@immutable
final class MediaFilters {
  /// Creates filters.
  ///
  /// [sortBy] is a TMDB `sort_by` value from [MediaSortOption.sortBy],
  /// or null for the catalog default.
  const new({this.genreId, this.sortBy});

  /// TMDB genre id, or null for every genre.
  final int? genreId;

  /// TMDB `sort_by` value, or null for the default order.
  final String? sortBy;

  /// Whether a genre or a sort is selected.
  bool get isActive => genreId != null || sortBy != null;

  @override
  bool operator ==(Object other) {
    return other is MediaFilters &&
        genreId == other.genreId &&
        sortBy == other.sortBy;
  }

  @override
  int get hashCode => Object.hash(genreId, sortBy);
}

/// One poster or person cell in the catalog.
@immutable
final class MediaItem {
  /// Creates a catalog cell.
  const new({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.voteAverage,
    this.subtitle,
  });

  /// TMDB id.
  final int id;

  /// Movie title, show title, or person name.
  final String title;

  /// Poster or profile URL, or null when TMDB has no image.
  final String? posterUrl;

  /// Average vote from 0 to 10. People use 0.
  final double voteAverage;

  /// Person department, or null for movies and shows.
  final String? subtitle;

  @override
  bool operator ==(Object other) {
    return other is MediaItem &&
        id == other.id &&
        title == other.title &&
        posterUrl == other.posterUrl &&
        voteAverage == other.voteAverage &&
        subtitle == other.subtitle;
  }

  @override
  int get hashCode => Object.hash(id, title, posterUrl, voteAverage, subtitle);
}

const _keepError = Object();

/// Immutable catalog screen state.
@immutable
final class MediaState {
  /// Creates catalog state.
  const new({
    this.contentType = MediaContentType.movies,
    this.searchQuery = '',
    this.filters = const MediaFilters(),
    this.movieGenres = const [],
    this.tvGenres = const [],
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.page = 0,
    this.endReached = false,
    this.favoriteIds = const <int>{},
  });

  /// Selected catalog section.
  final MediaContentType contentType;

  /// Raw search field text, including leading and trailing spaces.
  final String searchQuery;

  /// Genre and sort applied to movies and shows.
  final MediaFilters filters;

  /// Movie genres. Empty until they load, or when that load fails.
  final List<Genre> movieGenres;

  /// TV genres. Empty until they load, or when that load fails.
  final List<Genre> tvGenres;

  /// Current page of posters or people.
  final List<MediaItem> items;

  /// Whether the first page of the current request is in flight.
  final bool isLoading;

  /// Whether the next page is being appended.
  final bool isLoadingMore;

  /// Last failure text, or null.
  final String? error;

  /// Last page applied from TMDB. Zero before the first success.
  final int page;

  /// Whether [page] has reached TMDB `total_pages`.
  final bool endReached;

  /// Favorite movie ids. Empty until a session exists.
  final Set<int> favoriteIds;

  /// Genres for [contentType]. People have none.
  List<Genre> get genres {
    return switch (contentType) {
      MediaContentType.movies => movieGenres,
      MediaContentType.tv => tvGenres,
      MediaContentType.people => const [],
    };
  }

  /// Returns a copy with the given fields replaced.
  ///
  /// Pass [error] to replace the message. Omit it to keep the current one.
  MediaState copyWith({
    MediaContentType? contentType,
    String? searchQuery,
    MediaFilters? filters,
    List<Genre>? movieGenres,
    List<Genre>? tvGenres,
    List<MediaItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error = _keepError,
    int? page,
    bool? endReached,
    Set<int>? favoriteIds,
  }) {
    return MediaState(
      contentType: contentType ?? this.contentType,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      movieGenres: movieGenres ?? this.movieGenres,
      tvGenres: tvGenres ?? this.tvGenres,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _keepError) ? this.error : error as String?,
      page: page ?? this.page,
      endReached: endReached ?? this.endReached,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MediaState &&
        contentType == other.contentType &&
        searchQuery == other.searchQuery &&
        filters == other.filters &&
        listEquals(movieGenres, other.movieGenres) &&
        listEquals(tvGenres, other.tvGenres) &&
        listEquals(items, other.items) &&
        isLoading == other.isLoading &&
        isLoadingMore == other.isLoadingMore &&
        error == other.error &&
        page == other.page &&
        endReached == other.endReached &&
        setEquals(favoriteIds, other.favoriteIds);
  }

  @override
  int get hashCode => Object.hash(
    contentType,
    searchQuery,
    filters,
    Object.hashAll(movieGenres),
    Object.hashAll(tvGenres),
    Object.hashAll(items),
    isLoading,
    isLoadingMore,
    error,
    page,
    endReached,
    Object.hashAll(favoriteIds.toList()..sort()),
  );
}
