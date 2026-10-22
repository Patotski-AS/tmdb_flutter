import 'package:flutter/foundation.dart';

/// Movie or TV show credited to a person.
enum PersonCreditMediaType {
  /// A movie credit.
  movie,

  /// A TV credit.
  tv,
}

/// One combined-credit row for a person.
@immutable
final class PersonCredit {
  /// Creates a credit.
  const new({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.mediaType,
    required this.characterOrJob,
    required this.releaseDate,
    required this.voteAverage,
    required this.isCast,
  });

  /// TMDB movie or TV id.
  final int id;

  /// Movie title, or the TV name when the title is blank.
  final String title;

  /// Absolute poster URL, or null.
  final String? posterUrl;

  /// Movie or TV.
  final PersonCreditMediaType mediaType;

  /// Character for cast, job for crew. Null when the text is blank.
  final String? characterOrJob;

  /// `release_date`, or `first_air_date` when the release date is blank.
  final String? releaseDate;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// Whether this row came from the cast list.
  final bool isCast;

  @override
  bool operator ==(Object other) {
    return other is PersonCredit &&
        id == other.id &&
        title == other.title &&
        posterUrl == other.posterUrl &&
        mediaType == other.mediaType &&
        characterOrJob == other.characterOrJob &&
        releaseDate == other.releaseDate &&
        voteAverage == other.voteAverage &&
        isCast == other.isCast;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    posterUrl,
    mediaType,
    characterOrJob,
    releaseDate,
    voteAverage,
    isCast,
  );
}
