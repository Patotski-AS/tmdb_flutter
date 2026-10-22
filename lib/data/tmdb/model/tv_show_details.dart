import 'package:flutter/foundation.dart';
import 'package:tmdb_flutter/data/tmdb/model/cast_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/crew_member.dart';
import 'package:tmdb_flutter/data/tmdb/model/media_image.dart';
import 'package:tmdb_flutter/data/tmdb/model/tv_show.dart';
import 'package:tmdb_flutter/data/tmdb/model/video.dart';

/// Full TV card returned by `GET tv/{id}`.
@immutable
final class TvShowDetails {
  /// Creates a TV card.
  const new({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.voteAverage,
    required this.firstAirDate,
    required this.episodeRuntimeMinutes,
    required this.genres,
    required this.tagline,
    required this.backdropUrl,
    required this.originalName,
    required this.status,
    required this.originalLanguage,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.cast,
    required this.crew,
    required this.createdBy,
    required this.videos,
    required this.backdrops,
    required this.posters,
    required this.recommendations,
  });

  /// TMDB TV id.
  final int id;

  /// Localized name (`name` in the TMDB payload).
  final String title;

  /// Description. Empty when TMDB omits it.
  final String overview;

  /// Absolute poster URL, or null.
  final String? posterUrl;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// First air date `YYYY-MM-DD`, or null.
  final String? firstAirDate;

  /// First positive `episode_run_time` value, in minutes, or null.
  final int? episodeRuntimeMinutes;

  /// Localized genre names.
  final List<String> genres;

  /// Tagline, or null when TMDB sends a blank one.
  final String? tagline;

  /// Absolute backdrop URL, or null.
  final String? backdropUrl;

  /// Original name, or null when it is blank.
  final String? originalName;

  /// Localized status, or null when it is blank.
  final String? status;

  /// Original language code, or null when it is blank.
  final String? originalLanguage;

  /// Season count, or null when TMDB reports zero or omits it.
  final int? numberOfSeasons;

  /// Episode count, or null when TMDB reports zero or omits it.
  final int? numberOfEpisodes;

  /// Cast in TMDB order.
  final List<CastMember> cast;

  /// Full crew. The card keeps only the key jobs.
  final List<CrewMember> crew;

  /// Distinct non-blank creator names, in payload order.
  final List<String> createdBy;

  /// YouTube videos. Other sites are already removed.
  final List<Video> videos;

  /// Backdrop stills.
  final List<MediaImage> backdrops;

  /// Poster images.
  final List<MediaImage> posters;

  /// Recommended shows.
  final List<TvShow> recommendations;

  @override
  bool operator ==(Object other) {
    return other is TvShowDetails &&
        id == other.id &&
        title == other.title &&
        overview == other.overview &&
        posterUrl == other.posterUrl &&
        voteAverage == other.voteAverage &&
        firstAirDate == other.firstAirDate &&
        episodeRuntimeMinutes == other.episodeRuntimeMinutes &&
        listEquals(genres, other.genres) &&
        tagline == other.tagline &&
        backdropUrl == other.backdropUrl &&
        originalName == other.originalName &&
        status == other.status &&
        originalLanguage == other.originalLanguage &&
        numberOfSeasons == other.numberOfSeasons &&
        numberOfEpisodes == other.numberOfEpisodes &&
        listEquals(cast, other.cast) &&
        listEquals(crew, other.crew) &&
        listEquals(createdBy, other.createdBy) &&
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
      firstAirDate,
      episodeRuntimeMinutes,
      Object.hashAll(genres),
      tagline,
      backdropUrl,
    ),
    Object.hash(
      originalName,
      status,
      originalLanguage,
      numberOfSeasons,
      numberOfEpisodes,
      Object.hashAll(cast),
      Object.hashAll(crew),
      Object.hashAll(createdBy),
      Object.hashAll(videos),
      Object.hashAll(backdrops),
    ),
    Object.hash(Object.hashAll(posters), Object.hashAll(recommendations)),
  );
}
