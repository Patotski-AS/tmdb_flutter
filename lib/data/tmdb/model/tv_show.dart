import 'package:flutter/foundation.dart';

/// A TV row from a list, search, or discover response.
///
/// TMDB calls the title `name`. This model stores it as [title].
@immutable
final class TvShow {
  /// Creates a TV list item.
  const new({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.voteAverage,
    required this.firstAirDate,
  });

  /// TMDB TV id.
  final int id;

  /// Localized name (`name` in the TMDB payload).
  final String title;

  /// Short description. Empty when TMDB omits it.
  final String overview;

  /// Absolute poster URL, or null when TMDB has no poster.
  final String? posterUrl;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// First air date `YYYY-MM-DD`, or null.
  final String? firstAirDate;

  @override
  bool operator ==(Object other) {
    return other is TvShow &&
        id == other.id &&
        title == other.title &&
        overview == other.overview &&
        posterUrl == other.posterUrl &&
        voteAverage == other.voteAverage &&
        firstAirDate == other.firstAirDate;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, overview, posterUrl, voteAverage, firstAirDate);
}
