import 'package:flutter/foundation.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';

const _keep = Object();

/// Favorite movies shown at `/profile/favorites`.
@immutable
final class FavoritesState {
  /// Creates the favorites screen state.
  const new({
    this.movies = const [],
    this.isLoading = false,
    this.error,
  });

  /// Favorite movies already loaded.
  final List<Movie> movies;

  /// Whether a page request is in flight.
  final bool isLoading;

  /// Last failure text, or null.
  final String? error;

  /// Returns a copy with the given fields replaced.
  ///
  /// Pass [error] to replace it, including with null.
  /// Omit it to keep the current value.
  FavoritesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    Object? error = _keep,
  }) {
    return FavoritesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _keep) ? this.error : error as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FavoritesState &&
        listEquals(movies, other.movies) &&
        isLoading == other.isLoading &&
        error == other.error;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(movies), isLoading, error);
}
