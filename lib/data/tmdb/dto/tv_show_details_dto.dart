import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_flutter/data/tmdb/dto/details_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/genre_dto.dart';
import 'package:tmdb_flutter/data/tmdb/dto/tv_show_dto.dart';

part 'tv_show_details_dto.g.dart';

/// TV payload from `GET tv/{id}`.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class TvShowDetailsDto {
  /// Creates a TV details payload.
  const new({
    required this.id,
    required this.name,
    this.overview = '',
    this.posterPath,
    this.backdropPath,
    this.tagline,
    this.voteAverage = 0,
    this.firstAirDate,
    this.episodeRunTime = const [],
    this.genres = const [],
    this.originalName,
    this.status,
    this.originalLanguage,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.createdBy = const [],
    this.credits,
    this.videos,
    this.images,
    this.recommendations,
  });

  /// Parses a TV details object.
  factory fromJson(Map<String, dynamic> json) =>
      _$TvShowDetailsDtoFromJson(json);

  /// TMDB TV id.
  final int id;

  /// Localized name.
  final String name;

  /// Description. Empty when the field is missing or null.
  final String overview;

  /// Poster path, including the leading slash, or null.
  final String? posterPath;

  /// Backdrop path, including the leading slash, or null.
  final String? backdropPath;

  /// Tagline, or null.
  final String? tagline;

  /// Average vote from 0 to 10.
  final double voteAverage;

  /// First air date `YYYY-MM-DD`, or null.
  final String? firstAirDate;

  /// Episode runtimes in minutes. Empty when missing or null.
  final List<int> episodeRunTime;

  /// Genres. Empty when the field is missing or null.
  final List<GenreDto> genres;

  /// Original name, or null.
  final String? originalName;

  /// Status, or null.
  final String? status;

  /// Original language code, or null.
  final String? originalLanguage;

  /// Season count, or null.
  final int? numberOfSeasons;

  /// Episode count, or null.
  final int? numberOfEpisodes;

  /// Creators. Empty when the field is missing or null.
  final List<CreatedByDto> createdBy;

  /// Appended credits, or null when the field is missing.
  final CreditsDto? credits;

  /// Appended videos, or null when the field is missing.
  final VideosResponseDto? videos;

  /// Appended images, or null when the field is missing.
  final ImagesResponseDto? images;

  /// Appended recommendations, or null when the field is missing.
  final TvRecommendationsDto? recommendations;
}

/// `recommendations` object on a TV details response.
///
/// Unknown JSON keys are ignored.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
  checked: true,
)
final class TvRecommendationsDto {
  /// Creates a TV recommendations payload.
  const new({this.results = const []});

  /// Parses a TV recommendations object.
  factory fromJson(Map<String, dynamic> json) =>
      _$TvRecommendationsDtoFromJson(json);

  /// Recommended shows. Empty when the field is missing or null.
  final List<TvShowDto> results;
}
