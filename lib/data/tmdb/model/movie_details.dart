import 'package:flutter/foundation.dart';
import 'package:tmdb_flutter/data/tmdb/model/cast_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/crew_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_image.dart';
import 'package:tmdb_flutter/data/tmdb/model/movie.dart';
import 'package:tmdb_flutter/data/tmdb/model/video.dart';

/// Full movie card returned by `GET movie/{id}`.
@immutable
final class MovieDetails {
  /// Creates a movie card.
  const new({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.tagline,
    required this.backdropUrl,
    required this.originalTitle,
    required this.status,
    required this.originalLanguage,
    required this.budget,
    required this.revenue,
    required this.cast,
    required this.crew,
    required this.videos,
    required this.backdrops,
    required this.posters,
    required this.recommendations,
  });

  /// TMDB movie id.
  final int id;

  /// Localized title.
  final String title;

  /// Description. Empty when TMDB omits it.
  final String overview;

  /// Absolute poster URL, or null.
  final String? posterUrl;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// Release date `YYYY-MM-DD`, or null.
  final String? releaseDate;

  /// Runtime in minutes, or null.
  final int? runtime;

  /// Localized genre names.
  final List<String> genres;

  /// Tagline, or null when TMDB sends a blank one.
  final String? tagline;

  /// Absolute backdrop URL, or null.
  final String? backdropUrl;

  /// Original title, or null when it is blank.
  final String? originalTitle;

  /// Localized status, or null when it is blank.
  final String? status;

  /// Original language code, or null when it is blank.
  final String? originalLanguage;

  /// Budget in dollars. Zero means TMDB has no figure.
  final int budget;

  /// Revenue in dollars. Zero means TMDB has no figure.
  final int revenue;

  /// Cast in TMDB order.
  final List<CastMember> cast;

  /// Full crew. The card keeps only the key jobs.
  final List<CrewMember> crew;

  /// YouTube videos. Other sites are already removed.
  final List<Video> videos;

  /// Backdrop stills.
  final List<MediaImage> backdrops;

  /// Poster images.
  final List<MediaImage> posters;

  /// Recommended movies.
  final List<Movie> recommendations;

  @override
  bool operator ==(Object other) {
    return other is MovieDetails &&
        id == other.id &&
        title == other.title &&
        overview == other.overview &&
        posterUrl == other.posterUrl &&
        voteAverage == other.voteAverage &&
        releaseDate == other.releaseDate &&
        runtime == other.runtime &&
        listEquals(genres, other.genres) &&
        tagline == other.tagline &&
        backdropUrl == other.backdropUrl &&
        originalTitle == other.originalTitle &&
        status == other.status &&
        originalLanguage == other.originalLanguage &&
        budget == other.budget &&
        revenue == other.revenue &&
        listEquals(cast, other.cast) &&
        listEquals(crew, other.crew) &&
        listEquals(videos, other.videos) &&
        listEquals(backdrops, other.backdrops) &&
        listEquals(posters, other.posters) &&
        listEquals(recommendations, other.recommendations);
  }

  @override
  int get hashCode => Object.hash(
    Object.hash(
      id,
      title,
      overview,
      posterUrl,
      voteAverage,
      releaseDate,
      runtime,
      Object.hashAll(genres),
      tagline,
      backdropUrl,
    ),
    Object.hash(
      originalTitle,
      status,
      originalLanguage,
      budget,
      revenue,
      Object.hashAll(cast),
      Object.hashAll(crew),
      Object.hashAll(videos),
      Object.hashAll(backdrops),
      Object.hashAll(posters),
    ),
    Object.hashAll(recommendations),
  );
}
