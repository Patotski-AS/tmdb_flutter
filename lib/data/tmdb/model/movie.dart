import 'package:flutter/foundation.dart';

/// A movie row from a list, search, or discover response.
@immutable
final class Movie {
  /// Creates a movie list item.
  const new({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.voteAverage,
    required this.releaseDate,
  });

  /// TMDB movie id.
  final int id;

  /// Localized title.
  final String title;

  /// Short description. Empty when TMDB omits it.
  final String overview;

  /// Absolute poster URL, or null when TMDB has no poster.
  final String? posterUrl;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// Release date `YYYY-MM-DD`, or null.
  final String? releaseDate;

  @override
  bool operator ==(Object other) {
    return other is Movie &&
        id == other.id &&
        title == other.title &&
        overview == other.overview &&
        posterUrl == other.posterUrl &&
        voteAverage == other.voteAverage &&
        releaseDate == other.releaseDate;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, overview, posterUrl, voteAverage, releaseDate);
}
